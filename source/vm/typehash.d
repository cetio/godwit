/// Hash lookups utilized by class loaders for storing constructed types.
module godwit.typehash;

import godwit.dacenumerablehash;
import godwit.loaderallocator;
import godwit.state;

/**
 * Represents an entry within the EETypeHash, chaining together (hash, data) pairs.
 */
public struct EETypeHashEntry
{
public:
    /// Pointer to the data associated with the hash entry
    void* m_data;

    mixin accessors;
}

/**
 * Represents the EETypeHashTable utilized by class loaders for storing constructed types.
 * It is used for looking up arrays, pointers, and instantiations of user-defined generic types.
 */
public struct EETypeHashTable
{
    DacEnumerableHashTable!(EETypeHashTable, EETypeHashEntry, 2) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
    /// This is the domain in which the hash table is allocated
    LoaderAllocator* m_allocator;
    /*
#ifdef _DEBUG
    Volatile<LONG> m_dwSealCount; // Can more types be added to the table?
#endif
    */
    mixin accessors;
}