module godwit.backend.ilstubcache;

import godwit.backend.crst;
import godwit.backend.loaderheap;
import godwit.backend.methodtable;
import godwit.backend.method;
import godwit.backend.shash;
import caiman.traits;
import godwit.backend.loaderallocator;

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
    LoaderAllocator* m_allocator;
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