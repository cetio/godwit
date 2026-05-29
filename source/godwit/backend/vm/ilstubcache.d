module godwit.backend.vm.ilstubcache;

import godwit.backend.vm.crst;
import godwit.backend.inc.loaderheap;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.method;
import godwit.backend.inc.shash;
import godwit.backend.vm.loaderallocator;

public struct ILStubHashBlobBase
{
public:
final:
    // this is size of entire object!!
    size_t m_sizeOfBlob;

}

public struct ILStubHashBlob
{
    ILStubHashBlobBase ilStubHashBlobBase;
    alias ilStubHashBlobBase this;

public:
final:
    ubyte[] m_blobData;

}

public struct ILStubCache
{
public:
final:
    Crst m_crst;
    LoaderAllocator* m_allocator;
    MethodTable* m_stubMethodTable;
    SHash!(ILStubCacheEntry, uint) m_hashMap;

}

public struct ILStubCacheEntry
{
public:
final:
    MethodDesc* m_methodDesc;
    ILStubHashBlob* m_blob;

}