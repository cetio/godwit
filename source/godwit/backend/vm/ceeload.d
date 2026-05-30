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
public:
final:
    enum TransientFlags : uint
    {
        ModuleIsTenured = 0x00000001,
        ClassesFreed = 0x00000004,
        IsEditAndContinue = 0x00000008,
        IsProfilerNotified = 0x00000010,
        IsETWNotified = 0x00000020,

        DebuggerUserOverridePriv = 0x00000400,
        DebuggerAllowJITOptsPriv = 0x00000800,
        DebuggerTrackJITInfoPriv = 0x00001000,
        DebuggerEncEnabledPriv = 0x00002000,
        DebuggerPDBsCopied = 0x00004000,
        DebuggerIgnorePDBs = 0x00008000,
        DebuggerInfoMaskPriv = 0x0000fc00,
        DebuggerInfoShiftPriv = 10,

        IsIJWFixedUp = 0x00080000,
        IsBeingUnloaded = 0x00100000,
        ModuleReadyForTypeLoad = 0x00200000,

        TypeSpecsTriaged = 0x40000000,
        ModuleSaved = 0x80000000,
    }

    enum PersistentFlags : uint
    {
        ComputedGlobalClass = 0x00000002,
        ComputedStringInterning = 0x00000004,
        NoStringInterning = 0x00000008,
        ComputedWrapExceptions = 0x00000010,
        WrapExceptions = 0x00000020,
        ComputedReliabilityContract = 0x00000040,
        CollectibleModule = 0x00000080,
        ComputedIsPreV4Assembly = 0x00000100,
        IsPreV4Assembly = 0x00000200,
        DefaultDllImportSearchPathsIsCached = 0x00000400,
        DefaultDllImportSearchPathsStatus = 0x00000800,
        ComputedMethodDefToPropertyInfoMap = 0x00002000,
        LowLevelSystemAssemblyByName = 0x00004000,
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
    FileDef moduleRef;
    CrstExplicitInit crst;
    CrstExplicitInit fixupCrst;
    /// Debugging symbols reader interface.
    void* symUnmanagedReader;
    CrstExplicitInit symUnmanagedReaderCrst;
    /// Storage for the in-memory symbol stream if any debugger may retrieve this from out-of-process.
    void* streamSym;
    CrstExplicitInit lookupTableCrst;
    /// Linear mapping from TypeDef token to MethodTable *
    LookupMap!MethodTable typeDefToMethodTableMap;
    /// Linear mapping from TypeRef token to TypeHandle *
    LookupMap!TypeRef typeRefToMethodTableMap;
    /// Linear mapping from MethodDef token to MethodDesc *
    LookupMap!MethodDesc methodDefToDescMap;
    /// Linear mapping from FieldDef token to FieldDesc*
    LookupMap!FieldDesc fieldDefToDescMap;
    /// mapping from MemberRef token to MethodDesc*, FieldDesc*
    void* memberRefToDescHashTable;
    // Linear mapping from GenericParam token to TypeVarTypeDesc*
    LookupMap!TypeVarTypeDesc genericParamToDescMap;
    // Linear mapping from TypeDef token to the MethodTable * for its canonical generic instantiation
    LookupMap!MethodTable genericTypeDefToCanonMethodTableMap;
    /// Mapping from File token to Module *
    LookupMap!Module fileReferencesMap;
    /// Mapping of AssemblyRef token to Module *
    LookupMap!Module manifestModuleReferencesMap;
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
    void* moduleID;
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
    const(char)** assemblyRefByNameTable;
    uint assemblyRefByNameCount;
    Assembly** nativeMetadataAssemblyRefMap;
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
    void* dynamicILCrst;
    /// Maps tokens for EnC/dynamics/reflection emit to their corresponding IL blobs
    // this map *always* overrides the Metadata RVA
    void* dynamicILBlobTable;
    /// Maps tokens for to their corresponding overridden IL blobs
    // this map conditionally overrides the Metadata RVA and the DynamicILBlobTable
    void* temporaryILBlobTable;
    /// Hash table storing any profiler-provided instrumented IL offset mapping
    void* ilOffsetMappingTable;
    /// Strict count of # of methods in this module that are JMC-enabled.
    int numTotalJMCFuncs;
    bool defaultJMCStatus;

}