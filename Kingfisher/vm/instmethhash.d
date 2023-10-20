module vm.instmethhash;

import vm.dacenumerablehash;
import vm.loaderallocator;
import vm.method;

public struct InstMethodHashEntry
{
public:
    MethodDesc* data;
}

public struct InstMethodHashTable
{
    DacEnumerableHashTable!(InstMethodHashTable, InstMethodHashEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
    // This is the domain in which the hash table is allocated
    LoaderAllocator* allocator;
    /*
#ifdef _DEBUG
    Volatile<LONG> m_dwSealCount; // Can more types be added to the table?
#endif
    */
}