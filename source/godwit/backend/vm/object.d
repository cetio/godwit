/// Provides interface for C#/CLR objects & references
module godwit.backend.vm.object;

import godwit.backend.vm.methodtable;
import caiman.traits;
import godwit.impl;

alias ObjectRef = BaseObject*;
alias ObjectSoftRef = HollowObject*;
alias ObjectHandle = uint*;

/// Syncblock index & flags
public struct ObjHeader
{
public:
final:
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

    static if (HOST_x64)
    {
        uint padding;
    }
    SyncBlockFlags m_flags;

    mixin accessors;
}

/// Represents a C# Object
/// Directly contains type info and syncblock index
public struct BaseObject
{
public:
final:
    ObjHeader m_objHeader;
    MethodTable* m_methodTable;
    /// Byte array of object data, length is `methodTable.eeClass.layoutInfo.managedSize`
    ubyte m_data;

    mixin accessors;
}

/// Arbitrary reference to object, namely used for interop
public struct HollowObject
{
public:
final:
    /*ObjHeader objHeader()
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
    }*/
}

