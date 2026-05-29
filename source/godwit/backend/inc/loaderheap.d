module godwit.backend.inc.loaderheap;

import godwit.backend.inc.corhdr;
import godwit.impl;
import godwit.backend.inc.utilcode;

public struct LoaderHeapBlock
{
public:
final:
    LoaderHeapBlock* next;
    // The virtual address where this LoaderHeapBlock resides.
    void* virtualAddress;
    // The size of this block.
    size_t virtualSize;
    bool releaseMem;

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

    enum LoaderHeapDebugFlags : uint
    {
        /// Keep a permanent log of all callers
        CallTracing    = 0x00000001,
        /// One time flag to record that an OOM interrupted call tracing
        EncounteredOOM = 0x80000000,
    }

    /// Linked list of ClrVirtualAlloc'd pages
    LoaderHeapBlock* firstBlock;
    /// Allocation pointer in current block
    ubyte* allocPtr;
    /// Points to the end of the committed region in the current block
    ubyte* endCommittedRegion;
    ubyte* endReservedRegion;
    /// When we need to ClrVirtualAlloc() MEM_RESERVE a new set of pages, number of bytes to reserve
    uint reserveBlockSize;
    /// When we need to commit pages from our reserved list, number of bytes to commit at a time
    uint commitBlockSize;
    /// For interleaved heap (RX pages interleaved with RW ones), this specifies the allocation granularity,
    /// which is the individual code block size.
    uint granularity;
    /// Range list to record memory ranges in
    RangeList* rangeList;
    size_t totalAlloc;
    HeapKind kind;
    // This can't be right
    ptrdiff_t* firstFreeBlock;
    // This is used to hold on to a block of reserved memory provided to the
    // constructor. We do this instead of adding it as the first block because
    // that requires comitting the first page of the reserved block, and for
    // startup working set reasons we want to delay that as long as possible.
    LoaderHeapBlock reservedBlock;
    static if (DEBUG)
    {
        LoaderHeapDebugFlags debugFlags;
        LoaderHeapEvent* eventList;
        size_t numDebugWastedBytes;
        // Stubs allocated from a LoaderHeap will have unwind info registered with NT.
        // The info must be unregistered when the heap is destroyed.
        bool permitStubsWithUnwindInfo;
        bool stubUnwindInfoUnregistered;
    }
    /// Am I a LoaderHeap or an ExplicitControlLoaderHeap?
    bool explicitControl;
    void function(ubyte* pageBase, ubyte* pageBaseRX, size_t size) codePageGenerator;

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

    LoaderHeapEvent* next;
    AllocationType allocationType;
    const(char)* file;
    int lineNum;
    const(char)* allocFile;
    int allocLineNum;
    void* mem;
    size_t requestedSize;
    size_t size;
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
    // ILoaderHeapBackout loaderHeapBackout;
    // But I'm too lazy to implement this considering that I can't use multiple alias this
    // And ILoaderHeapBackout doesn't contain any fields.
    alias unlockedLoaderHeap this;
    //alias loaderHeapBackout this;

public:
final:
    CritSecCookie critSec;

}