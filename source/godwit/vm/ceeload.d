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
import caiman.traits;
import godwit.impl;
import godwit.loaderheap;

public struct LookupMap(T)
{
public:
final:
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
final:
    /// Linear mapping from TypeRef token to TypeHandle *
    LookupMap!TypeRef m_typeRefToMethodTableMap;
    /// Mapping of AssemblyRef token to Module *
    LookupMap!Module m_manifestModuleRefsMap;
    /// mapping from MemberRef token to MethodDesc*, FieldDesc*
    LookupMap!uint m_memberRefMap;
    /// For protecting additions to the heap
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
final:
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
final:
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

    /// Modules will store their name as a cached string for performance.
    const(char*) m_simpleName;
    /// Equivalent to assembly.peAssembly.
    PEAssembly* m_peAssembly;
    /// None of these flags survive a prejit save/restore.
    TransientFlags m_transientFlags;
    /// Will survive a prejit save/restore.
    PersistentFlags m_persistentFlags;
    /// Linked list of VASig cookie blocks = protected by m_pStubListCrst
    VASigCookieBlock* m_vaSigCookieBlock;
    /// Parent assembly.
    Assembly* m_assembly;
    CrstExplicitInit m_crst;
    CrstExplicitInit m_fixupCrst;
    /// Debugging symbols reader interface.
    // ----> ISymUnmanagedReader <----
    void* m_symUnmanagedReader;
    CrstExplicitInit m_symUnmanagedReaderCrst;
    /// Storage for the in-memory symbol stream if any debugger may retrieve this from out-of-process.
    // ----> CGrowableStream <----
    void* m_streamSym;
    /// Linear mapping from TypeDef token to MethodTable *
    // For generic types, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodTable m_typeDefToMethodTableMap;
    /// Linear mapping from MethodDef token to MethodDesc *
    // For generic methods, IsGenericTypeDefinition() is true i.e. instantiation at formals
    LookupMap!MethodDesc m_methodDefToDescMap;
    /// Linear mapping from FieldDef token to FieldDesc*
    LookupMap!FieldDesc m_fieldDefToDescMap;
    // Linear mapping from GenericParam token to TypeVarTypeDesc*
    LookupMap!TypeVarTypeDesc m_genericParamToDescMap;
    // Linear mapping from TypeDef token to the MethodTable * for its canonical generic instantiation
    // If the type is not generic, the entry is guaranteed to be NULL.  This means we are paying extra
    // space in order to use the LookupMap infrastructure, but what it buys us is IBC support and
    // a compressed format for NGen that makes up for it.
    LookupMap!MethodTable m_genericTypeDefToCanonMethodTableMap;
    /// Mapping from MethodDef token to pointer-sized value encoding property information
    LookupMap!size_t m_methodDefToPropertyInfoMap;
    /// IL stub cache with fabricated MethodTable parented by this module.
    ILStubCache* m_ilStubCache;
    uint m_defaultDllImportSearchPathsAttributeValue;
    /// Hash of available types by name
    EEClassHashTable* m_availableClasses;
    /// Hashtable of generic type instances
    EETypeHashTable* m_availableParamTypes;
    /// For protecting additions to m_pInstMethodHashTable
    CrstExplicitInit m_instMethodHashTableCrst;
    /// Hashtable of instantiated methods and per-instantiation static methods
    InstMethodHashTable* m_instMethodHashTable;
    uint m_debuggerJMCProbeCount;
    EEClassHashTable* m_availableClassesCaseIns;
    // ----> CoreLibBinder <----
    uint* m_binder;

    static if (READYTORUN)
    {
        ReadyToRunInfo* m_readyToRunInfo;
        NativeImage* m_nativeImage;
    }
    static if (PROFILING_SUPPORTED_DATA)
    {
        uint m_typeCount;
        uint m_exportedTypeCount;
        uint m_customAttributeCount;
    }
    static if (METADATA_UPDATER)
    {
        CUnorderedArray!(EnCEEClassData*, 5) m_classList;
    }
    /// LoaderHeap for storing IJW thunks
    LoaderHeap* m_thunkHeap;
    // ----> DomainLocalModule <----
    uint* m_moduleID;
    size_t m_moduleIndex;
    uint* m_regularStaticOffsets;
    uint* m_threadStaticOffsets;
    RID m_maxTypeRidStaticsAllocated;
    uint m_maxGCRegularStaticHandles;
    uint m_maxGCThreadStaticHandles;
    uint m_regularStaticsBlockSize;
    uint m_threadStaticsBlockSize;
    size_t m_numDynamicEntries;
    size_t m_maxDynamicEntries;
    MethodTable** m_dynamicStaticsInfo;
    
    DebuggerSpecificData m_debuggerSpecificData;
    static if (PROFILING_SUPPORTED || PROFILING_SUPPORTED_DATA)
    {
        JITInlineTrackingMap* m_jitInlinerTrackingMap;
    }
    const(char*) m_assemblyRefByNameTable;
    uint m_assemblyRefByNameCount;
    Assembly* m_nativeMetadataAssemblyRefMap;
    // For protecting dictionary layout slot expansions
    CrstExplicitInit m_dictionaryCrst;

    mixin accessors;
}

// This struct stores the data used by the managed debugging infrastructure.  If it turns out that
// the debugger is increasing the size of the Module class by too much, we can consider allocating
// this struct lazily on demand.
public struct DebuggerSpecificData
{
public:
final:
    /// Mutex protecting update access to the DynamicILBlobTable and TemporaryILBlobTable
    Crst* m_dynamicILCrst;
    /// Maps tokens for EnC/dynamics/reflection emit to their corresponding IL blobs
    // this map *always* overrides the Metadata RVA
    // ----> DynamicILBlobTable <----
    uint* m_dynamicILBlobTable;
    /// Maps tokens for to their corresponding overridden IL blobs
    // this map conditionally overrides the Metadata RVA and the DynamicILBlobTable
    // ----> DynamicILBlobTable <----
    uint* m_temporaryILBlobTable;
    /// Hash table storing any profiler-provided instrumented IL offset mapping
    // ----> ILOffsetMappingTable <----
    uint* m_ilOffsetMappingTable;
    /// Strict count of # of methods in this module that are JMC-enabled.
    int m_numTotalJMCFuncs;
    bool m_defaultJMCStatus;

    mixin accessors;
}