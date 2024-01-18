module godwit.backend.vm.dacenumerablehash;

import godwit.backend.vm.ceeload;
import godwit.backend.inc.loaderheap;
import caiman.traits;

public struct VolatileEntry(T)
{
public:
final:
    // The derived-class format of an entry
    T m_value;           
    // Pointer to the next entry in the bucket chain (or NULL)
    VolatileEntry* m_nextEntry;       
    // The hash value associated with the entry
    uint m_hashValue;    

    mixin accessors;
}

public struct DacEnumerableHashTable(FINAL, VALUE, int SCALE)
{
public:
final:
    Module* m_ceemodule;
    LoaderHeap* m_heap;
    VolatileEntry!VALUE* m_buckets;
    uint m_entries;

    mixin accessors;
}