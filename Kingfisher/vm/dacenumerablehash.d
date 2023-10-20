module vm.dacenumerablehash;

import vm.ceeload;
import inc.loaderheap;

struct VolatileEntry(T)
{
public:
    // The derived-class format of an entry
    T value;           
    // Pointer to the next entry in the bucket chain (or NULL)
    VolatileEntry* nextEntry;       
    // The hash value associated with the entry
    uint hashValue;       
};

public struct DacEnumerableHashTable(FINAL, VALUE, int SCALE)
{
public:
    Module* ceemodule;
    LoaderHeap* heap;
    VolatileEntry!VALUE* buckets;
    uint entries;
}