module godwit.backend.loaderallocator;

import godwit.backend.loaderheap;
import godwit.backend.codeman;
import godwit.backend.crst;
import godwit.backend.fptrstubs;
import godwit.backend.stringliteralmap;
import godwit.backend.object;
import caiman.traits;
import godwit.impl;
import godwit.backend.appdomain;
import godwit.backend.simplerwlock;
import godwit.backend.contractimpl;
import godwit.backend.domainassembly;
import godwit.backend.slist;
import godwit.backend.codeman;
import godwit.backend.stub;
import godwit.backend.listlock;
import godwit.backend.sbuffer;
import godwit.backend.utilcode;
import godwit.backend.shash;
import godwit.backend.hash;

public struct LoaderAllocator
{
public:
final:
    align(8) ubyte* m_initialReservedMemForLoaderHeaps;
    ubyte[LoaderHeap.sizeof] m_lowFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] m_highFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] m_stubHeapInstance;
    ubyte[CodeFragmentHeap.sizeof] m_precodeHeapInstance;
    ubyte[LoaderHeap.sizeof] m_fixupPrecodeHeapHeapInstance;
    ubyte[LoaderHeap.sizeof] m_newStubPrecodeHeapInstance;
    LoaderHeap* m_lowFreqHeap;
    LoaderHeap* m_highFreqHeap;
    /// Stubs for PInvoke, remoting, etc
    LoaderHeap* m_stubHeap;
    CodeFragmentHeap* m_precodeHeap;
    LoaderHeap* m_executableHeap;
    static if (READYTORUN)
    {
        CodeFragmentHeap* m_dynamicHelpersHeap;
    }
    LoaderHeap* m_fixupPrecodeHeap;
    LoaderHeap* m_newStubPrecodeHeap;
    ObjectHandle m_allocatorObjectHandle;
    /// For GetMultiCallableAddrOfCode()
    FuncPtrStubs* m_funcPtrStubs;
    /// The LoaderAllocator specific string literal map.
    StringLiteralMap* m_stringLiteralMap;
    CrstExplicitInit m_crstLoaderAllocator;
    bool m_gcPressure;
    bool m_unloaded;
    bool m_terminated;
    bool m_marked;
    int m_gcCount;
    bool m_isCollectible;

    /// Pre-allocated blocks of heap for collectible assemblies. Will be set to NULL as soon as it is used.
    ubyte* m_vsdHeapInitialAlloc;
    ubyte* m_codeHeapInitialAlloc;
    /// U->M thunks that are not associated with a delegate. \
    /// The cache is keyed by MethodDesc pointers.
    UMEntryThunkCache* m_umEntryThunkCache;
    CodeRangeMapRangeList m_stubPrecodeRangeList;
    CodeRangeMapRangeList m_fixupPrecodeRangeList;
    static if (PGO)
    {
        // ----> PgoManager <----
        uint* m_pgoManager;
    }

    BaseDomain* m_domain;
    /// ExecutionManager caches
    void* m_lastUsedCodeHeap;
    void* m_lastUsedDynamicCodeHeap;
    void* m_jumpStubCache;
    /// Used in LoaderAllocator GC process (during sweeping)
    LoaderAllocator* m_loaderAllocatorDestroyNext;
    static if (FAT_DISPATCH_TOKENS)
    {
        SimpleRWLock* m_fatTokenSetLock;
        // Wrong?
        SHash!(DispatchTokenFat*, uint)* m_pFatTokenSet;
    }

    // ----> VirtualCallStubManager <----
    uint* m_virtualCallStubManager;
    // Wrong?
    SHash!(LoaderAllocator*, uint) m_allocatorReferences;
    uint numRefs;
    DomainAssembly* m_firstDomainAssemblyFromSameALCToDelete;
    ulong numAllocator;

    SList!(FailedTypeInitCleanupListItem) m_failedTypeInitCleanupList;
    SegmentedHandleIndexStack m_freeHandleIndexesStack;
    static if (COM_INTEROP)
    {
        // ----> ComCallWrapperCache <----
        uint* m_comCallWrapperCache;
        /// Used for synchronizing creation of the m_comCallWrapperCache
        CrstExplicitInit m_ComCallWrapperCrst;
        /// Hash table that maps a MethodTable to COM Interop compatibility data.
        HashMap* m_interopDataHash;
    }
    /// Used for synchronizing access to the m_interopDataHash and m_pMarshalingData
    CrstExplicitInit m_interopDataCrst;
    // ----> EEMarshalingData <----
    uint* m_marshalingData;
    static if (TIERED_COMPILATION)
    {
        // ----> CallCountingManager <----
        uint* m_callCountingManager;
    }
    MethodDescBackpatchInfoTracker m_methodDescBackpatchInfoTracker;
    static if (ON_STACK_REPLACEMENT)
    {
        // ----> OnStackReplacementManager <----
        uint* m_onStackReplacementManager;
    }

    mixin accessors;
}

// crossloaderallocatorhash.h
// methoddescbackpatchinfo.h
public struct MethodDescBackpatchInfoTracker
{
public:
final:
    LoaderAllocator* m_allocator;
    SHash!(void*, uint) m_allocatorToDependentTrackerHash;
    SHash!(void*, uint) m_keyToDependentTrackersHash;

    mixin accessors;
}

public struct CodeRangeMapRangeList
{
    RangeList rangeList;
    alias rangeList this;

public:
final:
    SimpleRWLock m_rangeListRWLock;
    StubBlockKind m_rangeListType;
    SArray!(uint*) m_starts;
    void* m_id;
    bool m_collectible;
}

public struct FailedTypeInitCleanupListItem
{
public:
final:
    SLink m_link;
    ListLockEntry* m_listLockEntry;

    mixin accessors;
}

public struct SegmentedHandleIndexStack
{
public:
final:
    /// Segment containing the TOS
    Segment* m_tosSegment;
    /// One free segment to prevent rapid delete / new if pop / push happens rapidly
    /// at the boundary of two segments.
    Segment* m_freeSegment;
    /// Index of the top of stack in the TOS segment
    // SIZE
    int m_tosIndex;
}

public struct Segment
{
    Segment* m_prev;
    // SIZE
    uint[64] m_data;
}