module godwit.classhash;

import godwit.dacenumerablehash;
import caiman.traits;
import godwit.impl;

public struct EEClassHashEntry
{
public:
final:
    static if (DEBUG) 
    {
        const(char*[2]) m_debugKey;
    }
    // Either the token (if EECLASSHASH_TYPEHANDLE_DISCR), or the type handle encoded
    // as a relative pointer
    void* m_data;
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