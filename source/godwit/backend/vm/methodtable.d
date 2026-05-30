module godwit.backend.vm.methodtable;

import std.uuid;
import std.bitmanip;
import godwit.backend.vm.eeclass;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.genericdict;
import godwit.backend.inc.corhdr;
import godwit.backend.gc.gcdesc;
import godwit.backend.metadata;
import godwit.backend.vm.typehandle;
import godwit.impl;


public struct MethodTableWriteableData
{
public:
final:
    enum Flags : uint
    {
        Unrestored = 0x00000004,
        HasApproxParent = 0x00000010,
        UnrestoredTypeKey = 0x00000020,
        IsNotFullyLoaded = 0x00000040,
        DependenciesLoaded = 0x00000080,
        CanCompareBitsOrUseFastGetHashCode = 0x00000200,
        HasCheckedCanCompareBitsOrUseFastGetHashCode = 0x00000400,
    }

    uint flags;
    /// Non-unloadable context: internal RuntimeType object handle
    /// Unloadable context: slot index in LoaderAllocator's pinned table
    size_t exposedClassObject;

    static if (DEBUG)
    {
        uint lastVerifiedGCCnt;

        static if (HOST_x64)
        {
            uint padding;
        }
    }

}

public struct GuidInfo
{
public:
final:
    UUID guid;
    bool generatedFromName;

}

public struct InterfaceInfo
{
public:
final:
    MethodTable* methodTable;

}

public alias PerInstInfoElem = Dictionary*;
public alias PerInstInfo = PerInstInfoElem*;

public struct MethodTable
{
public:
final:
    enum WFlagsLow : uint
    {
        StaticsMask = 0x00000006,
        StaticsMaskNonDynamic = 0x00000000,
        StaticsMaskDynamic = 0x00000002,
        StaticsMaskGenerics = 0x00000004,
        StaticsMaskCrossModuleGenerics = 0x00000006,
        StaticsMaskIfGenericsThenCrossModule = 0x00000002,

        NotInPZM = 0x00000008,

        GenericsMask = 0x00000030,
        GenericsMaskNonGeneric = 0x00000000,
        GenericsMaskGenericInst = 0x00000010,
        GenericsMaskSharedInst = 0x00000020,
        GenericsMaskTypicalInst = 0x00000030,

        HasVariance = 0x00000100,
        HasDefaultCtor = 0x00000200,
        HasPreciseInitCctors = 0x00000400,

        IsHFA = 0x00000800,
        IsRegStructPassed = 0x00000800,

        IsByRefLike = 0x00001000,

        StringArrayValues = StaticsMaskNonDynamic | NotInPZM |
                            GenericsMaskNonGeneric,
    }

    enum WFlagsHigh : uint
    {
        CategoryMask = 0x000F0000,
        CategoryClass = 0x00000000,
        CategoryUnused1 = 0x00010000,
        CategoryUnused2 = 0x00020000,
        CategoryUnused3 = 0x00030000,
        CategoryValueType = 0x00040000,
        CategoryValueTypeMask = 0x000C0000,
        CategoryNullable = 0x00050000,
        CategoryPrimitiveValueType = 0x00060000,
        CategoryTruePrimitive = 0x00070000,
        CategoryArray = 0x00080000,
        CategoryArrayMask = 0x000C0000,
        IfArrayThenSzArray = 0x00020000,
        CategoryInterface = 0x000C0000,
        CategoryUnused4 = 0x000D0000,
        CategoryUnused5 = 0x000E0000,
        CategoryUnused6 = 0x000F0000,

        CategoryElementTypeMask = 0x000E0000,

        HasFinalizer = 0x00100000,
        IDynamicInterfaceCastable = 0x00200000,
        ICastable = 0x00400000,
        HasIndirectParent = 0x00800000,

        ContainsPointers = 0x01000000,
        HasTypeEquivalence = 0x02000000,
        IsTrackedReferenceWithFinalizer = 0x04000000,
        HasCriticalFinalizer = 0x08000000,
        Collectible = 0x10000000,
        ContainsGenericVariables = 0x20000000,
        ComObject = 0x40000000,
        HasComponentSize = 0x80000000,

        NonTrivialInterfaceCast = CategoryArray | ComObject | IDynamicInterfaceCastable |
                                ICastable | CategoryValueType,
    }

    enum WFlags2 : uint
    {
        MultipurposeSlotsMask = 0x001F,
        HasPerInstInfo = 0x0001,
        HasInterfaceMap = 0x0002,
        HasDispatchMapSlot = 0x0004,
        HasNonVirtualSlots = 0x0008,
        HasModuleOverride = 0x0010,

        IsZapped = 0x0020,
        IsPreRestored = 0x0040,
        HasModuleDependencies = 0x0080,

        IsIntrinsicType = 0x0100,
        RequiresDispatchTokenFat = 0x0200,
        HasCctor = 0x0400,
        HasVirtualStaticMethods = 0x0800,

        HasBoxedRegularStatics = 0x2000,
        HasSingleNonVirtualSlot = 0x4000,
        DependsOnEquivalentOrForwardedStructs = 0x8000,
    }

    enum RelatedTypeKind
    {
        EEClass = 0,
        Invalid = 1,
        MethodTable = 2,
        Indirection = 3,
    }

    enum : size_t
    {
        UNION_MASK = 3,
    }

    /// Low WORD is component size for array/string types; otherwise low flags.
    /// High WORD is category/type flags.
    uint flags;
    uint baseSize;
    ushort flags2;
    ushort _token;
    ushort numVirtuals;
    ushort numInterfaces;

    static if (DEBUG)
    {
        const(char)* debugClassName;
    }

    MethodTable* parentMethodTable;
    Module* ceemodule;
    MethodTableWriteableData* writeableData;

    union
    {
        EEClass* _eeClass;
        size_t canonMT;
    }

    union
    {
        PerInstInfo perInstInfo;
        size_t elementTypeHnd;
    }

    union
    {
        InterfaceInfo* interfaceMap;
        size_t encodedNullableUnboxData;
    }


    pragma(mangle, "MethodTable_relatedTypeKind_get")
    extern (C) export @property RelatedTypeKind relatedTypeKind()
    {
        return cast(RelatedTypeKind)(canonMT & UNION_MASK);
    }

    pragma(mangle, "MethodTable_relatedTypeKind_set")
    extern (C) export @property RelatedTypeKind relatedTypeKind(RelatedTypeKind val)
    {
        canonMT = (canonMT & ~UNION_MASK) | cast(size_t)val;
        return val;
    }

    pragma(mangle, "MethodTable_componentSize_get")
    extern (C) export @property ushort componentSize()
    {
        if ((flags & WFlagsHigh.HasComponentSize) == 0)
            return 0;

        version (BigEndian)
            return *(cast(ushort*)&flags + 1);
        else
            return *(cast(ushort*)&flags);
    }

    pragma(mangle, "MethodTable_componentSize_set")
    extern (C) export @property ushort componentSize(ushort val)
    {
        version (BigEndian)
            *(cast(ushort*)&flags + 1) = val;
        else
            *(cast(ushort*)&flags) = val;
        return val;
    }

    bool isIntegerSized()
    {
        uint managedSize = baseSize - cast(uint)(2 * size_t.sizeof);
        return ((managedSize & 1) == 0 && managedSize <= 8 && managedSize != 6);
    }

    uint typeDefRid()
    {
        return _token;
    }

    TypeDef token()
    {
        return tokenFromRid(cast(ushort)typeDefRid(), CorTokenType.TypeDef);
    }

    pragma(mangle, "MethodTable_gcDesc_get")
    extern (C) export GCDesc* gcDesc() const
        scope return
    {
        return cast(GCDesc*)&this;
    }

    pragma(mangle, "MethodTable_eeClass_get")
    extern (C) export @property EEClass* eeClass()
    {
        if (relatedTypeKind != RelatedTypeKind.EEClass)
            return canonMethodTable._eeClass;

        return _eeClass;
    }

    pragma(mangle, "MethodTable_canonMethodTable_get")
    extern (C) export @property MethodTable* canonMethodTable()
        scope return
    {
        if (relatedTypeKind == RelatedTypeKind.EEClass)
            return &this;

        if (relatedTypeKind == RelatedTypeKind.MethodTable)
            return cast(MethodTable*)(canonMT & ~UNION_MASK);

        return null;
    }

    pragma(mangle, "MethodTable_eeClass_set")
    extern (C) export @property EEClass* eeClass(EEClass* val)
    {
        if (relatedTypeKind != RelatedTypeKind.EEClass)
            return canonMethodTable()._eeClass = val;

        return _eeClass = val;
    }

    pragma(mangle, "MethodTable_canonMethodTable_set")
    extern (C) export @property MethodTable* canonMethodTable(MethodTable* val)
    {
        if (relatedTypeKind == RelatedTypeKind.MethodTable)
        {
            canonMT = cast(size_t)val | cast(size_t)RelatedTypeKind.MethodTable;
            return val;
        }

        return null;
    }

    void setEEClassUnsafe(EEClass* newEEClass)
    {
        relatedTypeKind = RelatedTypeKind.EEClass;
        eeClass = newEEClass;
    }

    void setCanonMethodTableUnsafe(MethodTable* newCanonMethodTable)
    {
        relatedTypeKind = RelatedTypeKind.MethodTable;
        canonMT = cast(size_t)newCanonMethodTable | cast(size_t)RelatedTypeKind.MethodTable;
    }
}