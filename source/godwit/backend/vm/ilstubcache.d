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
    size_t sizeOfBlob;

}

public struct ILStubHashBlob
{
    ILStubHashBlobBase ilStubHashBlobBase;
    alias ilStubHashBlobBase this;

public:
final:
    ubyte[] blobData;

}

public struct ILStubCache
{
public:
final:
    Crst crst;
    LoaderAllocator* allocator;
    MethodTable* stubMethodTable;
    SHash!(ILStubCacheEntry, uint) hashMap;

}

public struct ILStubCacheEntry
{
public:
final:
    MethodDesc* methodDesc;
    ILStubHashBlob* blob;

}