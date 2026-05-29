module godwit.backend.vm.classhash;

import godwit.backend.vm.dacenumerablehash;
import godwit.impl;

public struct EEClassHashEntry
{
public:
final:
    static if (DEBUG)
    {
        const(char*[2]) debugKey;
    }
    // Either the token (if EECLASSHASH_TYPEHANDLE_DISCR), or the type handle encoded
    // as a relative pointer
    void* data;
    EEClassHashEntry* encloser;

}

public struct EEClassHashTable
{
    DacEnumerableHashTable!(EEClassHashTable, EEClassHashEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    bool caseInsensitive;

}