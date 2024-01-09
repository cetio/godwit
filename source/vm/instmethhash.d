module godwit.instmethhash;

import godwit.dacenumerablehash;
import godwit.loaderallocator;
import godwit.method;
import godwit.mem.state;

public struct InstMethodHashEntry
{
public:
    MethodDesc* m_data;
}

public struct InstMethodHashTable
{
    DacEnumerableHashTable!(InstMethodHashTable, InstMethodHashEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
    // This is the domain in which the hash table is allocated
    LoaderAllocator* m_allocator;
    /*
#ifdef _DEBUG
    Volatile<LONG> m_dwSealCount; // Can more types be added to the table?
#endif
    */
    mixin accessors;
}