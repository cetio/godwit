module vm.dacenumerablehash;

import vm.ceeload;
import inc.loaderheap;
import state;

struct VolatileEntry(T)
{
public:
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
    Module* m_ceemodule;
    LoaderHeap* m_heap;
    VolatileEntry!VALUE* m_buckets;
    uint m_entries;

    mixin accessors;
}