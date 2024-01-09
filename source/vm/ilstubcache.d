module godwit.ilstubcache;

import godwit.crst;
import godwit.loaderheap;
import godwit.methodtable;
import godwit.method;
import godwit.shash;
import godwit.collections.state;

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