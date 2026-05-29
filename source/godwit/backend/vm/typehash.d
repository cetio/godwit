/// Hash lookups utilized by class loaders for storing constructed types.
module godwit.backend.vm.typehash;

import godwit.backend.vm.dacenumerablehash;
import godwit.backend.vm.loaderallocator;
import godwit.impl;

/**
 * Represents an entry within the EETypeHash, chaining together (hash, data) pairs.
 */
public struct EETypeHashEntry
{
public:
final:
    /// Pointer to the data associated with the hash entry
    void* data;

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
final:
    /// This is the domain in which the hash table is allocated
    LoaderAllocator* allocator;
    static if (DEBUG)
    {
        long sealCount; // Can more types be added to the table?
    }

}