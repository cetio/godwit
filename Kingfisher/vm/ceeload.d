module vm.ceeload;

import vm.siginfo;
import vm.crst;
import vm.assembly;
import vm.peassembly;
import vm.loaderallocator;
import vm.methodtable;
import inc.ilstubcache;
import vm.method;
import vm.field;
import vm.typedesc;
import inc.corhdr;
import vm.classhash;
import vm.typehash;
import vm.instmethhash;

public struct LookupMap(T)
{
public:
    LookupMap* next;
    T** table;
    // Number of elements in this node (only RIDs less than this value can be present in this node)
    uint count;
    // Set of flags that the map supports writing on top of the data value
    T* supportedFlags;
}

public struct ModuleBase
{
public:
    // Linear mapping from TypeRef token to TypeHandle *
    LookupMap!TypeRef typeRefToMethodTableMap;
    // Mapping of AssemblyRef token to Module *
    LookupMap!Module manifestModuleRefsMap;
    // mapping from MemberRef token to MethodDesc*, FieldDesc*
    LookupMap!void memberRefMap;
    // For protecting additions to the heap
    CrstExplicitInit lookupTableCrst;
    LoaderAllocator* loaderAllocator;
}

public struct VASigCookieBlock
{
public:
    VASigCookieBlock* next;
    uint numCookies;
    VASigCookie[] cookies;
}

public struct VASigCookie
{
public:
    uint sizeOfArgs;
    ubyte* ndirectILStub;
    Module* ceemodule;
    Signature signature;
}

// Equivalent to System.Reflection.Module.
public struct Module
{
    ModuleBase moduleBase;
    alias moduleBase this;

public:
    enum TransientFlags : uint
    {
        // Set once we know for sure the Module will not be freed until the appdomain itself exits
        ModuleIsTenured = 0x00000001,
        ClassesFreed = 0x00000004,
        IsEnc = 0x00000008,
        IsProfilerNotified = 0x00000010,
        IsETWNotified = 0x00000020,
        
        DebuggerUserOverridePriv = 0x00000400,
        DebuggerAllowJITOptsPriv = 0x00000800,
        DebuggerTrackJITInfoPriv = 0x00001000,
        // this is what was attempted to be set.  IS_EDIT_AND_CONTINUE is actual result.
        DebuggerEncEnabledPriv = 0x00002000,
        DebuggerPDBsCopied = 0x00004000,
        DebuggerInfoMaskPriv = 0x0000fc00,
        DebuggerInfoShiftPriv = 10,

        // Used to indicate that this module has had it's IJW fixups properly installed.
        IsIJWFixedUp = 0x00080000,
        IsBeingUnloaded = 0x00100000,
        // Used to indicate that the module is loaded sufficiently for generic candidate instantiations to work
        ModuleReadyForTypeLoad = 0x00200000,

        // Used during NGen only
        TypeSpecsTriaged = 0x40000000,
        ModuleSaved = 0x80000000,
    }

    enum PersistentFlags : uint
    {
        ComputedGlobalClass = 0x00000002,
        // This flag applies to assembly, but it is stored so it can be cached in ngen image
        ComputedWrapExceptions = 0x00000010,
        WrapExceptions = 0x00000020,
        ComputedReliabilityContract = 0x00000040,
        CollectibleModule = 0x00000080,

        //If attribute value has been cached before
        DefaultDllImportSearchPathsIsCached = 0x00000400,
        //If module has default dll import search paths attribute
        DefaultDllImportSearchPathsStatus = 0x00000800,

        //If m_MethodDefToPropertyInfoMap has been generated
        ComputedMethodDefToPropertyInfoMap = 0x00002000,
        RuntimeMarshalingEnabledIsCached = 0x00008000,
        RuntimeMarshalingEnabled = 0x00010000,
    }

    // Modules will store their name as a cached string for performance.
    char* simpleName;
    // Equivalent to assembly.peAssembly.
    PEAssembly* peAssembly;
    // None of these flags survive a prejit save/restore.
    TransientFlags transientFlags;
    // Will survive a prejit save/restore.
    PersistentFlags persistentFlags;
    // Linked list of VASig cookie blocks: protected by m_pStubListCrst
    VASigCookieBlock* vaSigCookieBlock;
    // Parent assembly.
    Assembly* assembly;
    CrstExplicitInit crst;
    CrstExplicitInit fixupCrst;
    // Debugging symbols reader interface. This will only be
    // initialized if needed, either by the debugging subsystem or for
    // an exception.
    // ISymUnmanagedReader
    void* symUnmanagedReader;
    // The reader lock is used to serialize all creation of symbol readers.
    // It does NOT seralize all access to the readers since we freely give
    // out references to the reader outside this struct.  Instead, once a
    // reader object is created, it is entirely read-only and so thread-safe.
    CrstExplicitInit symUnmanagedReaderCrst;
    // Storage for the in-memory symbol stream if any
    // Debugger may retrieve this from out-of-process.
    // PTR_CGrowableStream
    void* streamSym;
    // Linear mapping from TypeDef token to MethodTable *
    // For generic types, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodTable typeDefToMethodTableMap;
    // Linear mapping from MethodDef token to MethodDesc *
    // For generic methods, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodDesc methodDefToDescMap;
    // Linear mapping from FieldDef token to FieldDesc*
    LookupMap!FieldDesc fieldDefToDescMap;
    // Linear mapping from GenericParam token to TypeVarTypeDesc*
    LookupMap!TypeVarTypeDesc genericParamToDescMap;
    // Linear mapping from TypeDef token to the MethodTable * for its canonical generic instantiation
    // If the type is not generic, the entry is guaranteed to be NULL.  This means we are paying extra
    // space in order to use the LookupMap infrastructure, but what it buys us is IBC support and
    // a compressed format for NGen that makes up for it.
    LookupMap!MethodTable genericTypeDefToCanonMethodTableMap;
    // Mapping from MethodDef token to pointer-sized value encoding property information
    LookupMap!size_t methodDefToPropertyInfoMap;
    // IL stub cache with fabricated MethodTable parented by this module.
    ILStubCache* ilStubCache;
    uint defaultDllImportSearchPathsAttributeValue;
    // Hash of available types by name
    EEClassHashTable* availableClasses;
    // Hashtable of generic type instances
    EETypeHashTable* availableParamTypes;
    // For protecting additions to m_pInstMethodHashTable
    CrstExplicitInit instMethodHashTableCrst;
    // Hashtable of instantiated methods and per-instantiation static methods
    InstMethodHashTable* instMethodHashTable;
    // This is used by the Debugger. We need to store a uint
    // for a count of JMC functions. This is a count, not a pointer.
    // We'll pass the address of this field
    // off to the jit, which will include it in probes injected for
    // debuggable code.
    // This means we need the uint at the time a function is jitted.
    // The Debugger has its own module structure, but those aren't created
    // if a debugger isn't attached.
    // We put it here instead of in the debugger's module because:
    // 1) we need a module structure that's around even when the debugger
    // isn't attached... so we use the EE's module.
    // 2) Needs to be here for ngen
    uint debuggerJMCProbeCount;
    /*
#ifdef FEATURE_READYTORUN
    PTR_ReadyToRunInfo      m_pReadyToRunInfo;
    PTR_NativeImage         m_pNativeImage;
#endif

#if PROFILING_SUPPORTED_DATA
    DWORD                   m_dwTypeCount;
    DWORD                   m_dwExportedTypeCount;
    DWORD                   m_dwCustomAttributeCount;
#endif // PROFILING_SUPPORTED_DATA
    */
}