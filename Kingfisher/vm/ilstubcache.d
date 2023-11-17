module vm.ilstubcache;

import vm.crst;
import inc.loaderheap;
import vm.methodtable;
import vm.method;
import inc.shash;

public struct ILStubHashBlobBase
{
public:
    // this is size of entire object!!
    size_t sizeOfBlob;  
};

public struct ILStubHashBlob
{
    ILStubHashBlobBase ilStubHashBlobBase;
    alias ilStubHashBlobBase this;

public:
    ubyte[] blobData;
};

public struct ILStubCache
{
public:
    Crst crst;
    LoaderHeap* heap;
    MethodTable* stubMethodTable;
    SHash!(ILStubCacheEntry, uint) hashMap;

    Crst getCrst()
    {
        return crst;
    }

    LoaderHeap* getHeap()
    {
        return heap;
    }

    MethodTable* getStubMethodTable()
    {
        return stubMethodTable;
    }
}

public struct ILStubCacheEntry
{
public:
    MethodDesc* methodDesc;
    ILStubHashBlob* blob;
};