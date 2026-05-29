module godwit.backend.vm.contractimpl;

import godwit.backend.vm.hash;
import godwit.backend.vm.crst;
import godwit.impl;

public struct TypeIDMap
{
public:
final:
    HashMap idMap;
    HashMap mtMap;
    Crst lock;
    TypeIDProvider idProvider;
    uint entryCount;

}

public struct TypeIDProvider
{
public:
final:
    uint nextID;
    static if (FAT_DISPATCH_TOKENS)
    {
        uint nextFatID;
    }

}

public struct DispatchTokenFat
{
public:
final:
    uint typeId;
    uint slotNum;
}