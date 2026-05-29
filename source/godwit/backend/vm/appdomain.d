module godwit.backend.vm.appdomain;

import godwit.backend.vm.crst;
import godwit.backend.vm.assembly;
import godwit.backend.vm.object;
import godwit.backend.vm.listlock;
import godwit.backend.vm.defaultassemblybinder;
import godwit.backend.gc.gcinterface;
import godwit.backend.vm.contractimpl;
import godwit.backend.inc.sbuffer;
import godwit.backend.vm.object;
import godwit.backend.vm.mngstdinterfaces;
import godwit.backend.inc.shash;
import godwit.backend.vm.rcwrefcache;
import godwit.backend.vm.nativeimage;
import godwit.backend.vm.eehash;
import godwit.backend.vm.comreflectioncache;
import godwit.impl;
import godwit.backend.inc.arraylist;
import godwit.backend.vm.assemblyspec;
import godwit.backend.vm.typeequivalencehash;

public struct BaseDomain
{
public:
final:
    // Protects the list of assemblies in the domain
    ListLock fileLoadLock;
    CrstExplicitInit domainCrst;
    // Protects the Assembly and Unmanaged caches
    CrstExplicitInit domainCacheCrst;
    CrstExplicitInit domainLocalBlockCrst;
    // Used to protect the reference lists in the collectible loader allocators attached to this appdomain
    CrstExplicitInit crstLoaderAllocatorReferences;
    CrstExplicitInit crstStaticBoxInitLock;
    // Used to protect the assembly list. Taken also by GC or debugger thread, therefore we have to avoid
    // triggering GC while holding this lock (by switching the thread to GC_NOTRIGGER while it is held).
    CrstExplicitInit crstAssemblyList;
    ListLock classInitLock;
    JitListLock jitLock;
    ListLock ilStubGenLock;
    ListLock nativeTypeLoadLock;
    // Reference to the binding context that holds TPA list details
    DefaultAssemblyBinder* defaultBinder;
    IGCHandleStore handleStore;
    // The pinned heap handle table.
    PinnedHeapHandleTable pinnedHeapHandleTable;
    // Information regarding the managed standard interfaces.
    MngStdInterfacesInfo* mngStdInterfacesInfo;
    // I have yet to figure out an efficient way to get the number of handles
    // of a particular type that's currently used by the process without
    // spending more time looking at the handle table code. We know that
    // our only customer (asp.net) in Dev10 is not going to create many of
    // these handles so I am taking a shortcut for now and keep the sizedref
    // handle count on the AD itself.
    uint sizedRefHandles;
    TypeIDMap typeIDMap;
    // MethodTable to `typeIndex` map. `typeIndex` is embedded in the code during codegen.
    // During execution corresponding thread static data blocks are stored in `t_NonGCThreadStaticBlocks`
    // and `t_GCThreadStaticBlocks` array at the `typeIndex`.
    TypeIDMap nonGCThreadStaticBlockTypeIDMap;
    TypeIDMap gcThreadStaticBlockTypeIDMap;

}

public struct AppDomain
{
    BaseDomain baseDomain;
    alias baseDomain this;

public:
final:
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

    enum ContextFlags
    {
        ContextInitialize = 0x0001,
        // AppDomain was created using the APPDOMAIN_IGNORE_UNHANDLED_EXCEPTIONS flag
        IgnoreUnhandledExceptions = 0x10000,
    }

    CrstExplicitInit reflectionCrst;
    CrstExplicitInit refClassFactCrst;
    // Hash table that maps a class factory info to a COM comp.
    EEHashTable!(ClassFactoryInfo*, EEClassFactoryInfoHashTableHelper, true) refClassFactHash;
    static if (COM_INTEROP)
    {
        DispIDCache* refDispIDCache;
        // Handle points to Missing.Value Object which is used for [Optional] arg scenario during IDispatch CCW Call
        ObjectHandle hndMissing;
    }
    SString friendlyName;
    Assembly* rootAssembly;
    ContextFlags contextFlags;
    // When an application domain is created the ref count is artificially incremented
    // by one. For it to hit zero an explicit close must have happened.
    int refCount;
    // Map of loaded composite native images indexed by base load addresses
    CrstExplicitInit nativeImageLoadCrst;
    // Wrong?
    SHash!(char*, NativeImage*) nativeImageMap;
    static if (COM_INTEROP)
    {
        /// This cache stores the RCWs in this domain
        RCWRefCache* rcwCache;
    }
    static if (COM_WRAPPERS)
    {
        /// This cache stores the RCW -> CCW references in this domain
        RCWRefCache* rcwRefCache;
    }
    Stage stage;

    ArrayList failedAssemblies;
    AssemblySpecBindingCache assemblyCache;
    size_t memoryPressure;
    ArrayList nativeDllSearchDirectories;
    bool forceTrivialWaitOperations;
    SHash!(UnmanagedImageCacheEntry, uint) unmanagedCache;
    static if (TYPE_EQUIVALENCE)
    {
        TypeEquivalenceHashTable typeEquivalenceTable;
        CrstExplicitInit typeEquivalenceCrst;
    }
    // I can't see how these could be useful, so I'm not adding them
    /* static if (MULTICORE_JIT)
    {
        MulticoreJitManager multicoreJitManager;
    }
    static if (TIERED_COMPILATION)
    {
        TieredCompilationManager tieredCompilationManager;
    } */

}

public struct PinnedHeapHandleBucket
{
public:
final:
    PinnedHeapHandleBucket* next;
    int arraySize;
    int currentPos;
    int currentEmbeddedFreePos;
    ObjectHandle hndHandleArray;
    ObjectRef* arrayData;

}

public struct PinnedHeapHandleTable
{
public:
final:
    // The buckets of object handles.
    // synchronized by Crst
    PinnedHeapHandleBucket* head;
    // We need to know the containing domain so we know where to allocate handles
    BaseDomain* domain;
    // The size of the PinnedHeapHandleBucket.
    // synchronized by Crst
    uint nextBucketSize;
    // for finding and re-using embedded free items in the list
    // these fields are synchronized by Crst
    PinnedHeapHandleBucket* freeSearchHint;
    uint numEmbeddedFree;
    CrstExplicitInit crst;

}

public struct UnmanagedImageCacheEntry
{
public:
final:
    wchar* name;
    ptrdiff_t handle;

}