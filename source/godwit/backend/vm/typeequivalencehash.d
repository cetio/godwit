module godwit.backend.vm.typeequivalencehash;

import godwit.backend.vm.dacenumerablehash;
import godwit.backend.vm.crst;
import godwit.backend.vm.typehandle;

public struct TypeEquivalenceEntry
{
public:
final:
    TypeHandle m_partA;
    TypeHandle m_partB;
    bool m_isEquivalent;

}

public struct TypeEquivalenceHashTable
{
    DacEnumerableHashTable!(TypeEquivalenceHashTable, TypeEquivalenceEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    CrstExplicitInit* m_hashTableCrst;

}