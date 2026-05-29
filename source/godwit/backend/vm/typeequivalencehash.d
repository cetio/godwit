module godwit.backend.vm.typeequivalencehash;

import godwit.backend.vm.dacenumerablehash;
import godwit.backend.vm.crst;
import godwit.backend.vm.typehandle;

public struct TypeEquivalenceEntry
{
public:
final:
    TypeHandle partA;
    TypeHandle partB;
    bool isEquivalent;

}

public struct TypeEquivalenceHashTable
{
    DacEnumerableHashTable!(TypeEquivalenceHashTable, TypeEquivalenceEntry, 4) dacEnumerableHashTable;
    alias dacEnumerableHashTable this;

public:
final:
    CrstExplicitInit* hashTableCrst;

}