module godwit.backend.vm.loaderallocator;

import godwit.backend.inc.loaderheap;
import godwit.backend.vm.codeman;
import godwit.backend.vm.crst;
import godwit.backend.vm.fptrstubs;
import godwit.backend.vm.stringliteralmap;
import godwit.backend.vm.object;
import godwit.impl;
import godwit.backend.vm.appdomain;
import godwit.backend.simplerwlock;
import godwit.backend.vm.contractimpl;
import godwit.backend.vm.domainassembly;
import godwit.backend.inc.slist;
import godwit.backend.vm.codeman;
import godwit.backend.vm.stub;
import godwit.backend.vm.listlock;
import godwit.backend.inc.sbuffer;
import godwit.backend.inc.utilcode;
import godwit.backend.inc.shash;
import godwit.backend.vm.hash;

public struct LoaderAllocator
{
public:
final:
    align(8) ubyte* initialReservedMemForLoaderHeaps;
    ubyte[LoaderHeap.sizeof] lowFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] highFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] stubHeapInstance;
    ubyte[CodeFragmentHeap.sizeof] precodeHeapInstance;
    ubyte[LoaderHeap.sizeof] fixupPrecodeHeapHeapInstance;
    ubyte[LoaderHeap.sizeof] newStubPrecodeHeapInstance;
    LoaderHeap* lowFreqHeap;
    LoaderHeap* highFreqHeap;
    /// Stubs for PInvoke, remoting, etc
    LoaderHeap* stubHeap;
    CodeFragmentHeap* precodeHeap;
    LoaderHeap* executableHeap;
    static if (READYTORUN)
    {
        CodeFragmentHeap* dynamicHelpersHeap;
    }
    LoaderHeap* fixupPrecodeHeap;
    LoaderHeap* newStubPrecodeHeap;
    ObjectHandle allocatorObjectHandle;
    /// For GetMultiCallableAddrOfCode()
    FuncPtrStubs* funcPtrStubs;
    /// The LoaderAllocator specific string literal map.
    StringLiteralMap* stringLiteralMap;
    CrstExplicitInit crstLoaderAllocator;
    bool gcPressure;
    bool unloaded;
    bool terminated;
    bool marked;
    int gcCount;
    bool isCollectible;

    /// Pre-allocated blocks of heap for collectible assemblies. Will be set to NULL as soon as it is used.
    ubyte* vsdHeapInitialAlloc;
    ubyte* codeHeapInitialAlloc;
    /// U->M thunks that are not associated with a delegate. \
    /// The cache is keyed by MethodDesc pointers.
    UMEntryThunkCache* umEntryThunkCache;
    CodeRangeMapRangeList stubPrecodeRangeList;
    CodeRangeMapRangeList fixupPrecodeRangeList;
    static if (PGO)
    {
        // ----> PgoManager <----
        uint* pgoManager;
    }

    BaseDomain* domain;
    /// ExecutionManager caches
    void* lastUsedCodeHeap;
    void* lastUsedDynamicCodeHeap;
    void* jumpStubCache;
    /// Used in LoaderAllocator GC process (during sweeping)
    LoaderAllocator* loaderAllocatorDestroyNext;
    static if (FAT_DISPATCH_TOKENS)
    {
        SimpleRWLock* fatTokenSetLock;
        // Wrong?
        SHash!(DispatchTokenFat*, uint)* fatTokenSet;
    }

    // ----> VirtualCallStubManager <----
    uint* virtualCallStubManager;
    // Wrong?
    SHash!(LoaderAllocator*, uint) allocatorReferences;
    uint numRefs;
    DomainAssembly* firstDomainAssemblyFromSameALCToDelete;
    ulong numAllocator;

    SList!(FailedTypeInitCleanupListItem) failedTypeInitCleanupList;
    SegmentedHandleIndexStack freeHandleIndexesStack;
    static if (COM_INTEROP)
    {
        // ----> ComCallWrapperCache <----
        uint* comCallWrapperCache;
        /// Used for synchronizing creation of the comCallWrapperCache
        CrstExplicitInit ComCallWrapperCrst;
        /// Hash table that maps a MethodTable to COM Interop compatibility data.
        HashMap* interopDataHash;
    }
    /// Used for synchronizing access to the interopDataHash and marshalingData
    CrstExplicitInit interopDataCrst;
    // ----> EEMarshalingData <----
    uint* marshalingData;
    static if (TIERED_COMPILATION)
    {
        // ----> CallCountingManager <----
        uint* callCountingManager;
    }
    MethodDescBackpatchInfoTracker methodDescBackpatchInfoTracker;
    static if (ON_STACK_REPLACEMENT)
    {
        // ----> OnStackReplacementManager <----
        uint* onStackReplacementManager;
    }

}

// crossloaderallocatorhash.h
// methoddescbackpatchinfo.h
public struct MethodDescBackpatchInfoTracker
{
public:
final:
    LoaderAllocator* allocator;
    SHash!(void*, uint) allocatorToDependentTrackerHash;
    SHash!(void*, uint) keyToDependentTrackersHash;

}

public struct CodeRangeMapRangeList
{
    RangeList rangeList;
    alias rangeList this;

public:
final:
    SimpleRWLock rangeListRWLock;
    StubBlockKind rangeListType;
    SArray!(uint*) starts;
    void* id;
    bool collectible;
}

public struct FailedTypeInitCleanupListItem
{
public:
final:
    SLink link;
    ListLockEntry* listLockEntry;

}

public struct SegmentedHandleIndexStack
{
public:
final:
    /// Segment containing the TOS
    Segment* tosSegment;
    /// One free segment to prevent rapid delete / new if pop / push happens rapidly
    /// at the boundary of two segments.
    Segment* freeSegment;
    /// Index of the top of stack in the TOS segment
    // SIZE
    int tosIndex;
}

public struct Segment
{
    Segment* prev;
    // SIZE
    uint[64] data;
}