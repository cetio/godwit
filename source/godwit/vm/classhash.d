module godwit.classhash;

import godwit.dacenumerablehash;
import caiman.traits;

public struct EEClassHashEntry
{
public:
final:
    /*
#ifdef _DEBUG
    PTR_CUTF8                               DebugKey[2];    // Name of the type
#endif // _DEBUG
    */
    // Either the token (if EECLASSHASH_TYPEHANDLE_DISCR), or the type handle encoded
    // as a relative pointer
    void* m_data;
    // If this entry is a for a nested
    // class, this field stores a
    // reference to the enclosing type
    // reference to the enclosing type
    // (which must be in this same hash).
    EEClassHashEntry* m_encloser;

    mixin accessors;
}

public struct EEClassHashTable
{
    DacEnumerableHashTable!(EEClassHashTable, EEClassHashEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    bool m_caseInsensitive;

    mixin accessors;
}