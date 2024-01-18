module godwit.backend.vm.instmethhash;

import godwit.backend.vm.dacenumerablehash;
import godwit.backend.vm.loaderallocator;
import godwit.backend.vm.method;
import caiman.traits;
import godwit.impl;

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
    /// This is the domain in which the hash table is allocated
    LoaderAllocator* m_allocator;
    static if (DEBUG)
    {
        /// Can more types be added to the table?
        int m_sealCount;
    }

    mixin accessors;
}