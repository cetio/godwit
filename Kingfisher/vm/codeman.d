module vm.codeman;

import inc.loaderheap;
import vm.crst;
import vm.loaderallocator;

public struct FreeBlock
{
public:
    void* block;
    // Size of this block (includes size of FreeBlock)
    size_t size;            
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
    };

    LoaderAllocator* loaderAllocator;
    FreeBlock* freeBlocks;
    StubBlockKind kind;
    Crst crst;
}