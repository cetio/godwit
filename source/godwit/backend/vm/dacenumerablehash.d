module godwit.backend.vm.dacenumerablehash;

import godwit.backend.vm.ceeload;
import godwit.backend.inc.loaderheap;

public struct VolatileEntry(T)
{
public:
final:
    // The derived-class format of an entry
    T value;
    // Pointer to the next entry in the bucket chain (or NULL)
    VolatileEntry* nextEntry;
    // The hash value associated with the entry
    uint hashValue;

}

public struct DacEnumerableHashTable(FINAL, VALUE, int SCALE)
{
public:
final:
    Module* ceemodule;
    LoaderHeap* heap;
    VolatileEntry!VALUE* buckets;
    uint entries;

}