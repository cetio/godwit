module inc.loaderheap;

import inc.corhdr;

public struct LoaderHeapBlock
{
public:
    LoaderHeapBlock* next;
    // The virtual address where this LoaderHeapBlock resides.
    void* virtualAddress;
    // The size of this block.
    size_t virtualSize;
    bool releaseMem;

    LoaderHeapBlock* getNext()
    {
        return next;
    }

    void setNext(LoaderHeapBlock* newNext)
    {
        next = newNext;
    }

    void* getVirtualAddress()
    {
        return virtualAddress;
    }

    void setVirtualAddress(void* newVirtualAddress)
    {
        virtualAddress = newVirtualAddress;
    }

    size_t getVirtualSize()
    {
        return virtualSize;
    }

    void setVirtualSize(size_t newVirtualSize)
    {
        virtualSize = newVirtualSize;
    }

    bool getReleaseMem()
    {
        return releaseMem;
    }

    void setReleaseMem(bool newReleaseMem)
    {
        releaseMem = newReleaseMem;
    }
}

public struct UnlockedLoaderHeap
{
public:
    enum HeapKind
    {
        Data,
        Executable,
        Interleaved
    };

    // Linked list of ClrVirtualAlloc'd pages
    LoaderHeapBlock* firstBlock;
    // Allocation pointer in current block
    ubyte* allocPtr;
    // Points to the end of the committed region in the current block
    ubyte* endCommittedRegion;
    ubyte* endReservedRegion;
    // When we need to ClrVirtualAlloc() MEM_RESERVE a new set of pages, number of bytes to reserve
    uint reserveBlockSize;
    // When we need to commit pages from our reserved list, number of bytes to commit at a time
    uint commitBlockSize;
    // For interleaved heap (RX pages interleaved with RW ones), this specifies the allocation granularity,
    // which is the individual code block size
    uint granularity;
    // Range list to record memory ranges in
    // This should be a RangeList
    uint* rangeList;
    size_t totalAlloc;
    HeapKind kind;
    // This can't be right
    ptrdiff_t* firstFreeBlock;
    // This is used to hold on to a block of reserved memory provided to the
    // constructor. We do this instead of adding it as the first block because
    // that requires comitting the first page of the reserved block, and for
    // startup working set reasons we want to delay that as long as possible.
    LoaderHeapBlock reservedBlock;
    /*
#ifdef _DEBUG
    enum
    {
        kCallTracing    = 0x00000001,   // Keep a permanent log of all callers

        kEncounteredOOM = 0x80000000,   // One time flag to record that an OOM interrupted call tracing
    }
    LoaderHeapDebugFlags;

    DWORD               m_dwDebugFlags;

    LoaderHeapEvent    *m_pEventList;   // Linked list of events (in reverse time order)
    
    size_t              m_dwDebugWastedBytes;
    static DWORD        s_dwNumInstancesOfLoaderHeaps;
    // Stubs allocated from a LoaderHeap will have unwind info registered with NT.
    // The info must be unregistered when the heap is destroyed.
    BOOL                m_fPermitStubsWithUnwindInfo;
    BOOL                m_fStubUnwindInfoUnregistered;
#endif
    */
    // Am I a LoaderHeap or an ExplicitControlLoaderHeap?
    bool explicitControl;
}

public interface ILoaderHeapBackout
{
    
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
    CritSecCookie critSec;

    CritSecCookie getCritSec()
    {
        return critSec;
    }

    void setCritSec(CritSecCookie newCritSec)
    {
        critSec = newCritSec;
    }
}