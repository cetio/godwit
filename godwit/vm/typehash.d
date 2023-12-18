module godwit.typehash;

import godwit.dacenumerablehash;
import godwit.loaderallocator;
import godwit.state;

//========================================================================================
// This hash table is used by class loaders to look up constructed types:
// arrays, pointers and instantiations of user-defined generic types.
//
// Each persisted module structure has an EETypeHashTable used for constructed types that
// were ngen'ed into that module. See ceeload.hpp for more information about ngen modules.
//
// Types created at runtime are placed in an EETypeHashTable in BaseDomain.
//
// Keys are derivable from the data stored in the table (TypeHandle)
// - for an instantiated type, the typedef module, typedef token, and instantiation
// - for an array/pointer type, the CorElementType, rank, and type parameter
//
//========================================================================================

// One of these is present for each element in the table
// It simply chains together (hash,data) pairs
public struct EETypeHashEntry
{
public:
    void* m_data;

    mixin accessors;
}

public struct EETypeHashTable
{
    DacEnumerableHashTable!(EETypeHashTable, EETypeHashEntry, 2) dacEnumerableHashTable;
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