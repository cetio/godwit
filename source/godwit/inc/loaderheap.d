module godwit.loaderheap;

import godwit.corhdr;
import caiman.traits;
import godwit.impl;
import godwit.utilcode;

public struct LoaderHeapBlock
{
public:
final:
    LoaderHeapBlock* m_next;
    // The virtual address where this LoaderHeapBlock resides.
    void* m_virtualAddress;
    // The size of this block.
    size_t m_virtualSize;
    bool m_releaseMem;

    mixin accessors;
}

public struct UnlockedLoaderHeap
{
public:
final:
    enum HeapKind
    {
        Data,
        Executable,
        Interleaved
    }

    @flags enum LoaderHeapDebugFlags : uint
    {
        /// Keep a permanent log of all callers
        CallTracing    = 0x00000001, 
        /// One time flag to record that an OOM interrupted call tracing  
        EncounteredOOM = 0x80000000,   
    }

    /// Linked list of ClrVirtualAlloc'd pages
    LoaderHeapBlock* m_firstBlock;
    /// Allocation pointer in current block
    ubyte* m_allocPtr;
    /// Points to the end of the committed region in the current block
    ubyte* m_endCommittedRegion;
    ubyte* m_endReservedRegion;
    /// When we need to ClrVirtualAlloc() MEM_RESERVE a new set of pages, number of bytes to reserve
    uint m_reserveBlockSize;
    /// When we need to commit pages from our reserved list, number of bytes to commit at a time
    uint m_commitBlockSize;
    /// For interleaved heap (RX pages interleaved with RW ones), this specifies the allocation granularity,
    /// which is the individual code block size.
    uint m_granularity;
    /// Range list to record memory ranges in
    RangeList* m_rangeList;
    size_t m_totalAlloc;
    HeapKind m_kind;
    // This can't be right
    ptrdiff_t* m_firstFreeBlock;
    // This is used to hold on to a block of reserved memory provided to the
    // constructor. We do this instead of adding it as the first block because
    // that requires comitting the first page of the reserved block, and for
    // startup working set reasons we want to delay that as long as possible.
    LoaderHeapBlock m_reservedBlock;
    static if (DEBUG)
    {
        LoaderHeapDebugFlags m_debugFlags;
        LoaderHeapEvent* m_eventList;
        size_t m_numDebugWastedBytes;
        // Stubs allocated from a LoaderHeap will have unwind info registered with NT.
        // The info must be unregistered when the heap is destroyed.
        bool m_permitStubsWithUnwindInfo;
        bool m_stubUnwindInfoUnregistered;
    }
    /// Am I a LoaderHeap or an ExplicitControlLoaderHeap?
    bool m_explicitControl;
    @exempt void function(ubyte* pageBase, ubyte* pageBaseRX, size_t size) codePageGenerator;

    mixin accessors;
}

public struct LoaderHeapEvent
{
public:
final:
    enum AllocationType
    {
        AllocMem = 1,
        FreedMem = 4,
    }

    LoaderHeapEvent* m_next;
    AllocationType m_allocationType;
    const(char*) m_file;
    int m_lineNum;
    const(char*) m_allocFile;
    int m_allocLineNum;
    void* m_mem;
    size_t m_requestedSize;
    size_t m_size;
}

public interface ILoaderHeapBackout
{
    
}

public struct ExplicitControlLoaderHeap
{
    UnlockedLoaderHeap unlockedLoaderHeap;
    alias unlockedLoaderHeap this;
}

public struct LoaderHeap 
{
    UnlockedLoaderHeap unlockedLoaderHeap;
    // LoaderHeap is intended to inherit from
    // ILoaderHeapBackout iLoaderHeapBackout;
    // But I'm too lazy to implement this considering that I can't use multiple alias this
    // And ILoaderHeapBackout doesn't contain any fields.
    alias unlockedLoaderHeap this;
    //alias iLoaderHeapBackout this;

public:
final:
    CritSecCookie m_critSec;

    mixin accessors;
}