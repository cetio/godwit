module godwit.backend.typeequivalencehash;

import godwit.backend.dacenumerablehash;
import godwit.backend.crst;
import godwit.backend.typehandle;
import caiman.traits;

public struct TypeEquivalenceEntry
{
public:
final:
    TypeHandle m_partA;
    TypeHandle m_partB;
    bool m_isEquivalent;

    mixin accessors;
}

public struct TypeEquivalenceHashTable
{
    DacEnumerableHashTable!(TypeEquivalenceHashTable, TypeEquivalenceEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    CrstExplicitInit* m_hashTableCrst;

    mixin accessors;
}