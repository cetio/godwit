module vm.contractimpl;

import vm.hash;
import vm.crst;

public struct TypeIDMap
{
public:
    HashMap idMap;
    HashMap mtMap;
    Crst lock;
    TypeIDProvider idProvider;
    uint entryCount;
}

public struct TypeIDProvider
{
public:
    uint nextID;
    // #ifdef FAT_DISPATCH_TOKENS
    uint nextFatID;
}