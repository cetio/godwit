module godwit.ilstubcache;

import godwit.crst;
import godwit.loaderheap;
import godwit.methodtable;
import godwit.method;
import godwit.shash;
import caiman.traits;

public struct ILStubHashBlobBase
{
public:
final:
    // this is size of entire object!!
    size_t m_sizeOfBlob;  

    mixin accessors;
}

public struct ILStubHashBlob
{
    ILStubHashBlobBase ilStubHashBlobBase;
    alias ilStubHashBlobBase this;

public:
final:
    ubyte[] m_blobData;

    mixin accessors;
}

public struct ILStubCache
{
public:
final:
    Crst m_crst;
    LoaderHeap* m_heap;
    MethodTable* m_stubMethodTable;
    SHash!(ILStubCacheEntry, uint) m_hashMap;

    mixin accessors;
}

public struct ILStubCacheEntry
{
public:
final:
    MethodDesc* m_methodDesc;
    ILStubHashBlob* m_blob;

    mixin accessors;
}