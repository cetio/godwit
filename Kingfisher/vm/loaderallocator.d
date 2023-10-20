module vm.loaderallocator;

import inc.loaderheap;
import inc.codeman;
import vm.crst;
import inc.fptrstubs;
import vm.stringliteralmap;
import vm.objects;

public struct LoaderAllocator
{
public:
    align(8) ubyte* initialReservedMemForLoaderHeaps;
    ubyte[LoaderHeap.sizeof] lowFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] highFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] stubHeapInstance;
    ubyte[CodeFragmentHeap.sizeof] precodeHeapInstance;
    ubyte[LoaderHeap.sizeof] fixupPrecodeHeapHeapInstance;
    ubyte[LoaderHeap.sizeof] newStubPrecodeHeapInstance;
    LoaderHeap* lowFreqHeap;
    LoaderHeap* highFreqHeap;
    // stubs for PInvoke, remoting, etc
    LoaderHeap* stubHeap;
    CodeFragmentHeap* precodeHeap;
    LoaderHeap* executableHeap;
    /*
    #ifdef FEATURE_READYTORUN
    PTR_CodeFragmentHeap m_pDynamicHelpersHeap;
    #endif
    */
    LoaderHeap* fixupPrecodeHeap;
    LoaderHeap* newStubPrecodeHeap;
    ObjectHandle loaderAllocatorObjectHandle;
    // for GetMultiCallableAddrOfCode()
    FuncPtrStubs* funcPtrStubs;
    // The LoaderAllocator specific string literal map.
    StringLiteralMap* stringLiteralMap;
    CrstExplicitInit crstLoaderAllocator;
    bool gcPressure;
    bool unloaded;
    bool terminated;
    bool marked;
    int gcCount;
    bool isCollectible;
}