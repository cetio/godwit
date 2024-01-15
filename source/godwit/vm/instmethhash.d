module godwit.instmethhash;

import godwit.dacenumerablehash;
import godwit.loaderallocator;
import godwit.method;
import caiman.traits;

public struct InstMethodHashEntry
{
public:
final:
    MethodDesc* m_data;
}

public struct InstMethodHashTable
{
    DacEnumerableHashTable!(InstMethodHashTable, InstMethodHashEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    // This is the domain in which the hash table is allocated
    LoaderAllocator* m_allocator;
    /*
#ifdef _DEBUG
    Volatile<LONG> m_dwSealCount; // Can more types be added to the table?
#endif
    */
    mixin accessors;
}