module godwit.codeman;

import godwit.loaderheap;
import godwit.crst;
import godwit.loaderallocator;
import godwit.llv.traits;

public struct FreeBlock
{
public:
    void* m_block;
    // Size of this block (includes size of FreeBlock)
    size_t m_size;      

    mixin accessors;
}

public struct CodeFragmentHeap
{
    ILoaderHeapBackout iLoaderHeapBackout;
    alias iLoaderHeapBackout this;

public:
    enum StubBlockKind
    {
        Unknown,
        JumpStub,
        Precode,
        DynamicHelper,
        StubPrecode,
        FixupPrecode,
        VSDDispatchStub,
        VSDResolveStub,
        VSDLookupStub,
        VSDVTableStub,
        // Last valid value. Note that the definition is duplicated in debug\daccess\fntableaccess.cpp
        Last = 0xF,
        // Placeholders returned by code:GetStubCodeBlockKind
        NoCode,
        Managed,
        StubLink,
        // Placeholdes used by NGen images
        VirtualMethodThunk,
        ExternalMethodThunk,
        // Placeholdes used by ReadyToRun images
        MethodCallThunk,
    }

    LoaderAllocator* m_allocator;
    FreeBlock* m_freeBlocks;
    StubBlockKind m_kind;
    Crst m_crst;

    mixin accessors;
}