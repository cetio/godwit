module vm.ilstubcache;

import vm.crst;
import inc.loaderheap;
import vm.methodtable;
import vm.method;
import inc.shash;
import state;

public struct ILStubHashBlobBase
{
public:
    // this is size of entire object!!
    size_t m_sizeOfBlob;  

    mixin accessors;
}

public struct ILStubHashBlob
{
    ILStubHashBlobBase ilStubHashBlobBase;
    alias ilStubHashBlobBase this;

public:
    ubyte[] m_blobData;

    mixin accessors;
}

public struct ILStubCache
{
public:
    Crst m_crst;
    LoaderHeap* m_heap;
    MethodTable* m_stubMethodTable;
    SHash!(ILStubCacheEntry, uint) m_hashMap;

    mixin accessors;
}

public struct ILStubCacheEntry
{
public:
    MethodDesc* m_methodDesc;
    ILStubHashBlob* m_blob;

    mixin accessors;
}