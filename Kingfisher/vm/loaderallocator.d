module vm.loaderallocator;

import inc.loaderheap;
import vm.codeman;
import vm.crst;
import vm.fptrstubs;
import vm.stringliteralmap;
import vm.objects;
import state;

public struct LoaderAllocator
{
public:
    align(8) ubyte* m_initialReservedMemForLoaderHeaps;
    ubyte[LoaderHeap.sizeof] m_lowFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] m_highFreqHeapInstance;
    ubyte[LoaderHeap.sizeof] m_stubHeapInstance;
    ubyte[CodeFragmentHeap.sizeof] m_precodeHeapInstance;
    ubyte[LoaderHeap.sizeof] m_fixupPrecodeHeapHeapInstance;
    ubyte[LoaderHeap.sizeof] m_newStubPrecodeHeapInstance;
    LoaderHeap* m_lowFreqHeap;
    LoaderHeap* m_highFreqHeap;
    // stubs for PInvoke, remoting, etc
    LoaderHeap* m_stubHeap;
    CodeFragmentHeap* m_precodeHeap;
    LoaderHeap* m_executableHeap;
    /*
    #ifdef FEATURE_READYTORUN
    PTR_CodeFragmentHeap m_pDynamicHelpersHeap;
    #endif
    */
    LoaderHeap* m_fixupPrecodeHeap;
    LoaderHeap* m_newStubPrecodeHeap;
    ObjectHandle m_allocatorObjectHandle;
    // for GetMultiCallableAddrOfCode()
    FuncPtrStubs* m_funcPtrStubs;
    // The LoaderAllocator specific string literal map.
    StringLiteralMap* m_stringLiteralMap;
    CrstExplicitInit m_crstLoaderAllocator;
    bool m_gcPressure;
    bool m_unloaded;
    bool m_terminated;
    bool m_marked;
    int m_gcCount;
    bool m_isCollectible;

    mixin accessors;
}