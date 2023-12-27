module godwit.appdomain;

import godwit.crst;
import godwit.assembly;
import godwit.objects;
import godwit.listlock;
import godwit.defaultassemblybinder;
import godwit.gcinterface;
import godwit.contractimpl;
import godwit.sbuffer;
import godwit.objects;
import godwit.mngstdinterfaces;
import godwit.shash;
import godwit.rcwrefcache;
import godwit.nativeimage;
import godwit.eehash;
import godwit.state;
import godwit.comreflectioncache;

public struct BaseDomain
{
public:
    // Protects the list of assemblies in the domain
    ListLock m_fileLoadLock;
    CrstExplicitInit m_domainCrst;
    // Protects the Assembly and Unmanaged caches
    CrstExplicitInit m_domainCacheCrst;
    CrstExplicitInit m_domainLocalBlockCrst;
    // Used to protect the reference lists in the collectible loader allocators attached to this appdomain
    CrstExplicitInit m_crstLoaderAllocatorReferences;
    CrstExplicitInit m_crstStaticBoxInitLock;
    // Used to protect the assembly list. Taken also by GC or debugger thread, therefore we have to avoid
    // triggering GC while holding this lock (by switching the thread to GC_NOTRIGGER while it is held).
    CrstExplicitInit m_crstAssemblyList;
    ListLock m_classInitLock;
    JitListLock m_jitLock;
    ListLock m_ilStubGenLock;
    ListLock m_nativeTypeLoadLock;
    // Reference to the binding context that holds TPA list details
    DefaultAssemblyBinder* m_defaultBinder;
    IGCHandleStore m_handleStore;
    // The pinned heap handle table.
    PinnedHeapHandleTable m_pinnedHeapHandleTable;
    // Information regarding the managed standard interfaces.
    MngStdInterfacesInfo* m_mngStdInterfacesInfo;    
    // I have yet to figure out an efficient way to get the number of handles
    // of a particular type that's currently used by the process without
    // spending more time looking at the handle table code. We know that
    // our only customer (asp.net) in Dev10 is not going to create many of
    // these handles so I am taking a shortcut for now and keep the sizedref
    // handle count on the AD itself.
    uint m_sizedRefHandles;
    TypeIDMap m_typeIDMap;
    // MethodTable to `typeIndex` map. `typeIndex` is embedded in the code during codegen.
    // During execution corresponding thread static data blocks are stored in `t_NonGCThreadStaticBlocks`
    // and `t_GCThreadStaticBlocks` array at the `typeIndex`.
    TypeIDMap m_nonGCThreadStaticBlockTypeIDMap;
    TypeIDMap m_gcThreadStaticBlockTypeIDMap;

    mixin accessors;
}

public struct AppDomain
{
    BaseDomain baseDomain;
    alias baseDomain this;

public:
    enum Stage 
    {
        Creating,
        ReadyForManagedCode,
        Active,
        Open,
        // Don't delete the following *_DONOTUSE members and in case a new member needs to be added,
        // add it at the end. The reason is that debugger stuff has its own copy of this enum and
        // it can use the members that are marked as *_DONOTUSE here when debugging older version
        // of the runtime.
        UnloadRequested,
        Exiting,
        Exited,
        Finalizing,
        Finalized,
        HandleTableNoAccess,
        Cleared,
        Collected,
        Closed
    }

    @flags enum ContextFlags
    {
        ContextInitialize = 0x0001,
        // AppDomain was created using the APPDOMAIN_IGNORE_UNHANDLED_EXCEPTIONS flag
        IgnoreUnhandledExceptions = 0x10000, 
    }

    CrstExplicitInit m_reflectionCrst;
    CrstExplicitInit m_refClassFactCrst;
    // Hash table that maps a class factory info to a COM comp.
    // #ifdef FEATURE_COMINTEROP
    EEHashTable!(ClassFactoryInfo*, EEClassFactoryInfoHashTableHelper, true) m_refClassFactHash;
    DispIDCache* m_refDispIDCache;
    // Handle points to Missing.Value Object which is used for [Optional] arg scenario during IDispatch CCW Call
    ObjectHandle m_hndMissing;
    SString m_friendlyName;
    Assembly* m_rootAssembly;
    ContextFlags m_contextFlags;
    // When an application domain is created the ref count is artificially incremented
    // by one. For it to hit zero an explicit close must have happened.
    int m_refCount;
    // Map of loaded composite native images indexed by base load addresses
    CrstExplicitInit m_nativeImageLoadCrst;
    SHash!(char*, NativeImage*) m_nativeImageMap;
    // #ifdef FEATURE_COMINTEROP
    // this cache stores the RCWs in this domain
    RCWRefCache* m_rcwCache;
    // #ifdef FEATURE_COMWRAPPERS
    // this cache stores the RCW -> CCW references in this domain
    RCWRefCache* m_rcwRefCache; 
    Stage m_stage;

    mixin accessors;
}

public struct PinnedHeapHandleBucket
{
public:
    PinnedHeapHandleBucket* m_next;
    int m_arraySize;
    int m_currentPos;
    int m_currentEmbeddedFreePos;
    ObjectHandle m_hndHandleArray;
    ObjectRef* m_arrayData;

    mixin accessors;
}

public struct PinnedHeapHandleTable
{
public:
    // The buckets of object handles.
    // synchronized by m_Crst
    PinnedHeapHandleBucket* m_head;
    // We need to know the containing domain so we know where to allocate handles
    BaseDomain* m_domain;
    // The size of the PinnedHeapHandleBucket.
    // synchronized by m_Crst
    uint m_nextBucketSize;
    // for finding and re-using embedded free items in the list
    // these fields are synchronized by m_Crst
    PinnedHeapHandleBucket* m_freeSearchHint;
    uint m_numEmbeddedFree;
    CrstExplicitInit m_crst;

    mixin accessors;
}