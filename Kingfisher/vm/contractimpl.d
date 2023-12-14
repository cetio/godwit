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

    HashMap getIdMap()
    {
        return idMap;
    }

    void setIdMap(HashMap newIdMap)
    {
        idMap = newIdMap;
    }

    HashMap getMtMap()
    {
        return mtMap;
    }

    void setMtMap(HashMap newMtMap)
    {
        mtMap = newMtMap;
    }

    Crst getLock()
    {
        return lock;
    }

    void setLock(Crst newLock)
    {
        lock = newLock;
    }

    TypeIDProvider getIdProvider()
    {
        return idProvider;
    }

    void setIdProvider(TypeIDProvider newIdProvider)
    {
        idProvider = newIdProvider;
    }

    uint getEntryCount()
    {
        return entryCount;
    }

    void setEntryCount(uint newEntryCount)
    {
        entryCount = newEntryCount;
    }
}

public struct TypeIDProvider
{
public:
    uint nextID;
    // #ifdef FAT_DISPATCH_TOKENS
    uint nextFatID;

    uint getNextID()
    {
        return nextID;
    }

    void setNextID(uint newNextID)
    {
        nextID = newNextID;
    }

    uint getNextFatID()
    {
        return nextFatID;
    }

    void setNextFatID(uint newNextFatID)
    {
        nextFatID = newNextFatID;
    }
}