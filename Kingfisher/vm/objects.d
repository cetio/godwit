module vm.objects;

import vm.methodtable;

alias ObjectRef = BaseObject*;
alias ObjectSoftRef = HollowObject*;
alias ObjectHandle = uint*;

public struct ObjHeader
{
public:
    enum SyncBlockFlags : uint
    {
        StringHasNoHighChars = 0x80000000,
        AgileInProgress = 0x80000000,
        StringHighCharsKnown = 0x40000000,
        StringHasSpecialSort = 0xC0000000,
        StringHighCharMask = 0xC0000000,
        FinalizerRun = 0x40000000,
        GcReserve = 0x20000000,
        SpinLock = 0x10000000,
        IsHashOrSyncblkindex = 0x08000000,
        IsHashcode = 0x04000000
    }

    int padding;
    SyncBlockFlags flags;
}

public struct BaseObject
{
public:
    ObjHeader objHeader;
    MethodTable* methodTable;
    ubyte data;

    ObjHeader getObjHeader()
    {
        return objHeader;
    }

    MethodTable* getMethodTable()
    {
        return methodTable;
    }

    ubyte getData()
    {
        return data;
    }
}

public struct HollowObject
{
public:
    ObjHeader getObjHeader()
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).objHeader;
    }

    MethodTable* getMethodTable()
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).methodTable;
    }

    ubyte getData()
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).data;
    }
}

