module godwit.backend.vm.typeequivalencehash;

import godwit.backend.vm.dacenumerablehash;
import godwit.backend.vm.crst;
import godwit.backend.vm.typehandle;
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