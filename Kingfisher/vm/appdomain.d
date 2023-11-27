module vm.appdomain;

import vm.crst;
import vm.assembly;
import vm.objects;
import vm.listlock;
import vm.defaultassemblybinder;
import gc.gcinterface;
import vm.contractimpl;
import inc.sbuffer;
import vm.objects;
import vm.mngstdinterfaces;
import inc.shash;
import vm.rcwrefcache;
import vm.nativeimage;
import vm.eehash;
import vm.comreflectioncache;

public struct BaseDomain
{
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
    };

    enum ContextFlags
    {
        ContextInitialize = 0x0001,
        // AppDomain was created using the APPDOMAIN_IGNORE_UNHANDLED_EXCEPTIONS flag
        IgnoreUnhandledExceptions = 0x10000, 
    };

    CrstExplicitInit reflectionCrst;
    CrstExplicitInit refClassFactCrst;
    // Hash table that maps a class factory info to a COM comp.
    // #ifdef FEATURE_COMINTEROP
    EEHashTable!(ClassFactoryInfo*, EEClassFactoryInfoHashTableHelper, true) refClassFactHash;
    DispIDCache* refDispIDCache;
    // Handle points to Missing.Value Object which is used for [Optional] arg scenario during IDispatch CCW Call
    ObjectHandle hndMissing;
    SString friendlyName;
    Assembly* rootAssembly;
    ContextFlags contextFlags;
    // When an application domain is created the ref count is artificially incremented
    // by one. For it to hit zero an explicit close must have happened.
    int refCount;
    // Map of loaded composite native images indexed by base load addresses
    CrstExplicitInit nativeImageLoadCrst;
    SHash!(char*, NativeImage*) nativeImageMap;
    // #ifdef FEATURE_COMINTEROP
    // this cache stores the RCWs in this domain
    RCWRefCache* rcwCache;
    // #ifdef FEATURE_COMWRAPPERS
    // this cache stores the RCW -> CCW references in this domain
    RCWRefCache* rcwRefCache; 
    Stage stage;

    extern(C) export CrstExplicitInit getReflectionCrst()
    {
        return reflectionCrst;
    }

    extern(C) export void setReflectionCrst(CrstExplicitInit val)
    {
        reflectionCrst = val;
    }

    extern(C) export CrstExplicitInit getRefClassFactCrst()  
    {
        return refClassFactCrst;
    }

    extern(C) export void setRefClassFactCrst(CrstExplicitInit val)
    {  
        refClassFactCrst = val;   
    }

    extern(C) export EEHashTable!(ClassFactoryInfo*, EEClassFactoryInfoHashTableHelper, true) getRefClassFactHash()   
    {
        return refClassFactHash;
    }  

    extern(C) export void setRefClassFactHash(EEHashTable!(ClassFactoryInfo*, EEClassFactoryInfoHashTableHelper, true) val)
    {
        refClassFactHash = val;
    }

    extern(C) export DispIDCache* getRefDispIDCache()   
    {
        return refDispIDCache;
    }

    extern(C) export void setRefDispIDCache(DispIDCache* val)  
    {
        refDispIDCache = val;
    }

    extern(C) export ObjectHandle getHndMissing()   
    {
        return hndMissing;
    }

    extern(C) export void setHndMissing(ObjectHandle val)  
    {
        hndMissing = val;   
    }

    extern(C) export SString getFriendlyName()  
    {
        return friendlyName;
    }

    extern(C) export void setFriendlyName(SString val)
    {
        friendlyName = val;
    }

    extern(C) export Assembly* getRootAssembly()
    {
        return rootAssembly;
    }

    extern(C) export void setRootAssembly(Assembly* val) 
    {
        rootAssembly = val;
    }

    extern(C) export ContextFlags getContextFlags()
    {
        return contextFlags;
    }

    extern(C) export bool isContextInitialize()
    {
        return contextFlags.GetFlag(ContextFlags.ContextInitialize);
    }

    extern(C) export void setIsContextInitialize(bool state)
    {
        contextFlags.SetFlag(ContextFlags.ContextInitialize, state)
    }

    extern(C) export bool isIgnoreUnhandledExceptions() 
    {
        return contextFlags.GetFlag(ContextFlags.IgnoreUnhandledExceptions);
    }

    extern(C) export void SetIgnoreUnhandledExceptions(bool state)
    {
        contextFlags.SetFlag(ContextFlags.IgnoreUnhandledExceptions, state);
    }

    extern(C) export CrstExplicitInit getNativeImageLoadCrst()
    {
        return nativeImageLoadCrst;
    }

    extern(C) export void setNativeImageLoadCrst(CrstExplicitInit value)  
    {
    nativeImageLoadCrst = value;
    }

    extern(C) export SHash!(char*, NativeImage*) getNativeImageMap() 
    {
        return nativeImageMap;
    }  

    extern(C) export void setNativeImageMap(SHash!(char*, NativeImage*) value)
    {
        nativeImageMap = value;
    }

    extern(C) export RCWRefCache* getRCWCache()  
    {
        return rcwCache;
    }

    extern(C) export void setRCWCache(RCWRefCache* value) 
    {
        rcwCache = value;
    }  

    extern(C) export RCWRefCache* getRCWRefCache()
    {
        return rcwRefCache;
    }

    extern(C) export void setRCWRefCache(RCWRefCache* value)
    {
        rcwRefCache = value;
    }

    extern(C) export Stage getStage()
    {
        return stage;  
    }  

    extern(C) export void setStage(Stage value)  
    {
        stage = value;
    }
}

public struct PinnedHeapHandleBucket
{
public:
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
    // The buckets of object handles.
    // synchronized by m_Crst
    PinnedHeapHandleBucket* head;
    // We need to know the containing domain so we know where to allocate handles
    BaseDomain* domain;
    // The size of the PinnedHeapHandleBucket.
    // synchronized by m_Crst
    uint nextBucketSize;
    // for finding and re-using embedded free items in the list
    // these fields are synchronized by m_Crst
    PinnedHeapHandleBucket* freeSearchHint;
    uint numEmbeddedFree;
    CrstExplicitInit crst;
}