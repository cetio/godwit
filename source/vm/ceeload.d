module godwit.ceeload;

import godwit.siginfo;
import godwit.crst;
import godwit.assembly;
import godwit.peassembly;
import godwit.loaderallocator;
import godwit.methodtable;
import godwit.ilstubcache;
import godwit.method;
import godwit.field;
import godwit.typedesc;
import godwit.corhdr;
import godwit.classhash;
import godwit.typehash;
import godwit.instmethhash;
import godwit.llv.traits;

public struct LookupMap(T)
{
public:
    LookupMap* m_next;
    T** m_table;
    // Number of elements in this node (only RIDs less than this value can be present in this node)
    uint m_count;
    // Set of flags that the map supports writing on top of the data value
    T* m_supportedFlags;

    mixin accessors;
}

public struct ModuleBase
{
public:
    // Linear mapping from TypeRef token to TypeHandle *
    LookupMap!TypeRef m_typeRefToMethodTableMap;
    // Mapping of AssemblyRef token to Module *
    LookupMap!Module m_manifestModuleRefsMap;
    // mapping from MemberRef token to MethodDesc*, FieldDesc*
    LookupMap!void m_memberRefMap;
    // For protecting additions to the heap
    CrstExplicitInit m_lookupTableCrst;
    LoaderAllocator* m_allocator;

    mixin accessors;
}

public struct VASigCookieBlock
{
public:
    VASigCookieBlock* m_next;
    uint m_numCookies;
    VASigCookie[] m_cookies;

    mixin accessors;
}

public struct VASigCookie
{
public:
    uint m_sizeOfArgs;
    ubyte* m_ndirectILStub;
    Module* m_ceemodule;
    Signature m_signature;

    mixin accessors;
}

// Equivalent to System.Reflection.Module.
public struct Module
{
    ModuleBase moduleBase;
    alias moduleBase this;

public:
    @flags enum TransientFlags : uint
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

    @flags enum PersistentFlags : uint
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
    char* m_simpleName;
    // Equivalent to assembly.peAssembly.
    PEAssembly* m_peAssembly;
    // None of these flags survive a prejit save/restore.
    TransientFlags m_transientFlags;
    // Will survive a prejit save/restore.
    PersistentFlags m_persistentFlags;
    // Linked list of VASig cookie blocks = protected by m_pStubListCrst
    VASigCookieBlock* m_vaSigCookieBlock;
    // Parent assembly.
    Assembly* m_assembly;
    CrstExplicitInit m_crst;
    CrstExplicitInit m_fixupCrst;
    // Debugging symbols reader interface. This will only be
    // initialized if needed, either by the debugging subsystem or for
    // an exception.
    // ISymUnmanagedReader
    void* m_symUnmanagedReader;
    // The reader lock is used to serialize all creation of symbol godwit.
    // It does NOT seralize all access to the readers since we freely give
    // out references to the reader outside this struct.  Instead, once a
    // reader object is created, it is entirely read-only and so thread-safe.
    CrstExplicitInit m_symUnmanagedReaderCrst;
    // Storage for the in-memory symbol stream if any
    // Debugger may retrieve this from out-of-process.
    // PTR_CGrowableStream
    void* m_streamSym;
    // Linear mapping from TypeDef token to MethodTable *
    // For generic types, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodTable m_typeDefToMethodTableMap;
    // Linear mapping from MethodDef token to MethodDesc *
    // For generic methods, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodDesc m_methodDefToDescMap;
    // Linear mapping from FieldDef token to FieldDesc*
    LookupMap!FieldDesc m_fieldDefToDescMap;
    // Linear mapping from GenericParam token to TypeVarTypeDesc*
    LookupMap!TypeVarTypeDesc m_genericParamToDescMap;
    // Linear mapping from TypeDef token to the MethodTable * for its canonical generic instantiation
    // If the type is not generic, the entry is guaranteed to be NULL.  This means we are paying extra
    // space in order to use the LookupMap infrastructure, but what it buys us is IBC support and
    // a compressed format for NGen that makes up for it.
    LookupMap!MethodTable m_genericTypeDefToCanonMethodTableMap;
    // Mapping from MethodDef token to pointer-sized value encoding property information
    LookupMap!size_t m_methodDefToPropertyInfoMap;
    // IL stub cache with fabricated MethodTable parented by this module.
    ILStubCache* m_ilStubCache;
    uint m_defaultDllImportSearchPathsAttributeValue;
    // Hash of available types by name
    EEClassHashTable* m_availableClasses;
    // Hashtable of generic type instances
    EETypeHashTable* m_availableParamTypes;
    // For protecting additions to m_pInstMethodHashTable
    CrstExplicitInit m_instMethodHashTableCrst;
    // Hashtable of instantiated methods and per-instantiation static methods
    InstMethodHashTable* m_instMethodHashTable;
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
    uint m_debuggerJMCProbeCount;
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
    mixin accessors;
}