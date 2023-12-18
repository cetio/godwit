module vm.objects;

import vm.methodtable;
import state;

alias ObjectRef = BaseObject*;
alias ObjectSoftRef = HollowObject*;
alias ObjectHandle = uint*;

public struct ObjHeader
{
public:
    @flags enum SyncBlockFlags : uint
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
    SyncBlockFlags m_flags;

    mixin accessors;
}

public struct BaseObject
{
public:
    ObjHeader m_objHeader;
    MethodTable* m_methodTable;
    ubyte m_data;

    mixin accessors;
}

public struct HollowObject
{
public:
    ObjHeader objHeader()
        scope return
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).objHeader;
    }

    MethodTable* methodTable()
        scope return
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).methodTable;
    }

    ubyte data()
        scope return
    {
        return (cast(BaseObject*)(cast(ubyte*)&this - 16)).data;
    }
}

