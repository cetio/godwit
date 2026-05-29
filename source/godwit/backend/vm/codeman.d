module godwit.backend.vm.codeman;

import godwit.backend.inc.loaderheap;
import godwit.backend.vm.crst;
import godwit.backend.vm.loaderallocator;

public struct FreeBlock
{
public:
final:
    void* block;
    // Size of this block (includes size of FreeBlock)
    size_t size;

}

public enum StubBlockKind
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
    // Placeholders used by NGen images
    VirtualMethodThunk,
    ExternalMethodThunk,
    // Placeholders used by ReadyToRun images
    MethodCallThunk
}

public struct CodeFragmentHeap
{
    ILoaderHeapBackout loaderHeapBackout;
    alias loaderHeapBackout this;

public:
final:


    LoaderAllocator* allocator;
    FreeBlock* freeBlocks;
    StubBlockKind kind;
    Crst crst;

}