module godwit.backend.vm.ceeload;

import godwit.backend.siginfo;
import godwit.backend.vm.crst;
import godwit.backend.vm.assembly;
import godwit.backend.vm.peassembly;
import godwit.backend.vm.loaderallocator;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.ilstubcache;
import godwit.backend.vm.method;
import godwit.backend.vm.field;
import godwit.backend.vm.typedesc;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.classhash;
import godwit.backend.vm.typehash;
import godwit.backend.vm.instmethhash;
import godwit.impl;
import godwit.backend.inc.loaderheap;

public struct LookupMap(T)
{
public:
final:
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
final:
    /// Linear mapping from TypeRef token to TypeHandle *
    LookupMap!TypeRef typeRefToMethodTableMap;
    /// Mapping of AssemblyRef token to Module *
    LookupMap!Module manifestModuleRefsMap;
    /// mapping from MemberRef token to MethodDesc*, FieldDesc*
    LookupMap!uint memberRefMap;
    /// For protecting additions to the heap
    CrstExplicitInit lookupTableCrst;
    LoaderAllocator* allocator;

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
final:
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
final:
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

        //If MethodDefToPropertyInfoMap has been generated
        ComputedMethodDefToPropertyInfoMap = 0x00002000,
        RuntimeMarshalingEnabledIsCached = 0x00008000,
        RuntimeMarshalingEnabled = 0x00010000,
    }

    /// Modules will store their name as a cached string for performance.
    const(char)* simpleName;
    /// Equivalent to assembly.peAssembly.
    PEAssembly* peAssembly;
    /// None of these flags survive a prejit save/restore.
    TransientFlags transientFlags;
    /// Will survive a prejit save/restore.
    PersistentFlags persistentFlags;
    /// Linked list of VASig cookie blocks = protected by stubListCrst
    VASigCookieBlock* vaSigCookieBlock;
    /// Parent assembly.
    Assembly* assembly;
    CrstExplicitInit crst;
    CrstExplicitInit fixupCrst;
    /// Debugging symbols reader interface.
    // ----> ISymUnmanagedReader <----
    void* symUnmanagedReader;
    CrstExplicitInit symUnmanagedReaderCrst;
    /// Storage for the in-memory symbol stream if any debugger may retrieve this from out-of-process.
    // ----> CGrowableStream <----
    void* streamSym;
    /// Linear mapping from TypeDef token to MethodTable *
    // For generic types, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodTable typeDefToMethodTableMap;
    /// Linear mapping from MethodDef token to MethodDesc *
    // For generic methods, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodDesc methodDefToDescMap;
    /// Linear mapping from FieldDef token to FieldDesc*
    LookupMap!FieldDesc fieldDefToDescMap;
    // Linear mapping from GenericParam token to TypeVarTypeDesc*
    LookupMap!TypeVarTypeDesc genericParamToDescMap;
    // Linear mapping from TypeDef token to the MethodTable * for its canonical generic instantiation
    // If the type is not generic, the entry is guaranteed to be NULL.  This means we are paying extra
    // space in order to use the LookupMap infrastructure, but what it buys us is IBC support and
    // a compressed format for NGen that makes up for it.
    LookupMap!MethodTable genericTypeDefToCanonMethodTableMap;
    /// Mapping from MethodDef token to pointer-sized value encoding property information
    LookupMap!size_t methodDefToPropertyInfoMap;
    /// IL stub cache with fabricated MethodTable parented by this module.
    ILStubCache* ilStubCache;
    uint defaultDllImportSearchPathsAttributeValue;
    /// Hash of available types by name
    EEClassHashTable* availableClasses;
    /// Hashtable of generic type instances
    EETypeHashTable* availableParamTypes;
    /// For protecting additions to instMethodHashTable
    CrstExplicitInit instMethodHashTableCrst;
    /// Hashtable of instantiated methods and per-instantiation static methods
    InstMethodHashTable* instMethodHashTable;
    uint debuggerJMCProbeCount;
    EEClassHashTable* availableClassesCaseIns;
    // ----> CoreLibBinder <----
    uint* binder;

    static if (READYTORUN)
    {
        ReadyToRunInfo* readyToRunInfo;
        NativeImage* nativeImage;
    }
    static if (PROFILING_SUPPORTED_DATA)
    {
        uint typeCount;
        uint exportedTypeCount;
        uint customAttributeCount;
    }
    static if (METADATA_UPDATER)
    {
        CUnorderedArray!(EnCEEClassData*, 5) classList;
    }
    /// LoaderHeap for storing IJW thunks
    LoaderHeap* thunkHeap;
    // ----> DomainLocalModule <----
    uint* moduleID;
    size_t moduleIndex;
    uint* regularStaticOffsets;
    uint* threadStaticOffsets;
    RID maxTypeRidStaticsAllocated;
    uint maxGCRegularStaticHandles;
    uint maxGCThreadStaticHandles;
    uint regularStaticsBlockSize;
    uint threadStaticsBlockSize;
    size_t numDynamicEntries;
    size_t maxDynamicEntries;
    MethodTable** dynamicStaticsInfo;

    DebuggerSpecificData debuggerSpecificData;
    static if (PROFILING_SUPPORTED || PROFILING_SUPPORTED_DATA)
    {
        JITInlineTrackingMap* jitInlinerTrackingMap;
    }
    const(char)* assemblyRefByNameTable;
    uint assemblyRefByNameCount;
    Assembly* nativeMetadataAssemblyRefMap;
    // For protecting dictionary layout slot expansions
    CrstExplicitInit dictionaryCrst;

}

// This struct stores the data used by the managed debugging infrastructure.  If it turns out that
// the debugger is increasing the size of the Module class by too much, we can consider allocating
// this struct lazily on demand.
public struct DebuggerSpecificData
{
public:
final:
    /// Mutex protecting update access to the DynamicILBlobTable and TemporaryILBlobTable
    Crst* dynamicILCrst;
    /// Maps tokens for EnC/dynamics/reflection emit to their corresponding IL blobs
    // this map *always* overrides the Metadata RVA
    // ----> DynamicILBlobTable <----
    uint* dynamicILBlobTable;
    /// Maps tokens for to their corresponding overridden IL blobs
    // this map conditionally overrides the Metadata RVA and the DynamicILBlobTable
    // ----> DynamicILBlobTable <----
    uint* temporaryILBlobTable;
    /// Hash table storing any profiler-provided instrumented IL offset mapping
    // ----> ILOffsetMappingTable <----
    uint* ilOffsetMappingTable;
    /// Strict count of # of methods in this module that are JMC-enabled.
    int numTotalJMCFuncs;
    bool defaultJMCStatus;

}