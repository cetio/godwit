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


public struct MethodTableAuxiliaryData
{
public:
final:
    @flags enum Flags : uint
    {
        Initialized = 0x0001,
        HasCheckedCanCompareBitsOrUseFastGetHashCode = 0x0002,
        CanCompareBitsOrUseFastGetHashCode = 0x0004,
        IsTlsIndexAllocated = 0x0008,
        HasApproxParent = 0x0010,
        MayHaveOpenInterfaceInInterfaceMap = 0x0020,
        IsNotFullyLoaded = 0x0040,
        DependenciesLoaded = 0x0080,
        IsInitError = 0x0100,
        IsStaticDataAllocated = 0x0200,
        HasCheckedStreamOverride = 0x0400,
        StreamOverriddenRead = 0x0800,
        StreamOverriddenWrite = 0x1000,
        EnsuredInstanceActive = 0x2000,
    }

    union
    {
        Flags m_flags;
        struct
        {
            ushort m_loFlags;
            short m_offsetToNonVirtualSlots;
        }
    }

    int m_cachedVersionResilientHashCode;
    Module* m_loaderModule;
    /// Non-unloadable context: internal RuntimeType object handle
    /// Unloadable context: slot index in LoaderAllocator's pinned table
    uint* m_exposedClassObject;

    static if (DEBUG)
    {
        @flags enum DebugFlags : uint
        {
            IsPublished = 0x2000,
            ParentMethodTablePointerValid = 0x4000,
            HasInjectedInterfaceDuplicates = 0x8000,
        }

        DebugFlags m_debugFlags;
        uint m_lastVerifiedGCCnt;

        static if (HOST_x64)
        {
            uint padding;
        }

        void* m_debugOnlyDynamicStatics;
        void* m_debugOnlyGenericStatics;
        void* m_debugOnlyThreadStatics;
    }

// mixin accessors;
}

public struct GuidInfo
{
public:
final:
    UUID m_guid;
    bool m_generatedFromName;

// mixin accessors;
}

public struct InterfaceInfo
{
public:
final:
    MethodTable* m_methodTable;

// mixin accessors;
}

public alias PerInstInfoElem = Dictionary*;
public alias PerInstInfo = PerInstInfoElem*;

public struct MethodTable
{
public:
final:
    @flags enum WFlagsLow : uint
    {
        HasCriticalFinalizer = 0x00000002,

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
        HasBoxedRegularStatics = 0x00002000,
        HasBoxedThreadStatics = 0x00004000,

        StringArrayValues = (GenericsMask & GenericsMaskNonGeneric),
    }

    @flags enum WFlagsHigh : uint
    {
        CategoryMask = 0x000F0000,
        CategoryClass = 0x00000000,
        CategoryValueType = 0x00040000,
        CategoryNullable = 0x00050000,
        CategoryPrimitive = 0x00060000,
        CategoryTruePrimitive = 0x00070000,
        CategoryArray = 0x00080000,
        CategoryArrayMask = 0x000C0000,
        IfArrayThenSzArray = 0x00020000,
        CategoryInterface = 0x000C0000,

        CategoryElementTypeMask = 0x000E0000,

        HasFinalizer = 0x00100000,
        Collectible = 0x00200000,

        RequiresAlign8 = 0x00800000,

        ContainsGCPointers = 0x01000000,
        HasTypeEquivalence = 0x02000000,
        IsTrackedReferenceWithFinalizer = 0x04000000,
        IDynamicInterfaceCastable = 0x10000000,
        ContainsGenericVariables = 0x20000000,
        ComObject = 0x40000000,
        HasComponentSize = 0x80000000,

        NonTrivialInterfaceCast = CategoryArray | ComObject | IDynamicInterfaceCastable | CategoryValueType,
    }

    @flags enum WFlags2 : uint
    {
        HasPerInstInfo = 0x0001,
        DynamicStatics = 0x0002,
        HasDispatchMapSlot = 0x0004,

        IsIntrinsicType = 0x0020,
        HasCctor = 0x0040,
        HasVirtualStaticMethods = 0x0080,

        TokenMask = 0xFFFFFF00,
    }

    enum RelatedTypeKind
    {
        EEClass = 0,
        CanonMT = 1,
    }

    enum : size_t
    {
        UNION_MASK = 1,
    }

    /// Low WORD is component size for array/string types; otherwise low flags.
    /// High WORD is category/type flags.
    uint m_flags;
    uint m_baseSize;
    uint m_flags2;
    ushort m_numVirtuals;
    ushort m_numInterfaces;

    static if (DEBUG)
    {
        const(char)* debugClassName;
    }

    MethodTable* m_parentMethodTable;
    Module* m_module;
    MethodTableAuxiliaryData* m_auxiliaryData;

    union
    {
        EEClass* m_eeClass;
        size_t m_canonMT;
    }

    union
    {
        PerInstInfo m_perInstInfo;
        size_t m_elementTypeHnd;
    }

    union
    {
        InterfaceInfo* m_interfaceMap;
        size_t m_encodedNullableUnboxData;
    }

// mixin accessors;

    pragma(mangle, "MethodTable_relatedTypeKind_get")
    extern (C) export @property RelatedTypeKind relatedTypeKind()
    {
        return cast(RelatedTypeKind)(m_canonMT & UNION_MASK);
    }

    pragma(mangle, "MethodTable_relatedTypeKind_set")
    extern (C) export @property RelatedTypeKind relatedTypeKind(RelatedTypeKind val)
    {
        m_canonMT = (m_canonMT & ~UNION_MASK) | cast(size_t)val;
        return val;
    }

    pragma(mangle, "MethodTable_componentSize_get")
    extern (C) export @property ushort componentSize()
    {
        if ((m_flags & WFlagsHigh.HasComponentSize) == 0)
            return 0;

        version (BigEndian)
            return *(cast(ushort*)&m_flags + 1);
        else
            return *(cast(ushort*)&m_flags);
    }

    pragma(mangle, "MethodTable_componentSize_set")
    extern (C) export @property ushort componentSize(ushort val)
    {
        version (BigEndian)
            *(cast(ushort*)&m_flags + 1) = val;
        else
            *(cast(ushort*)&m_flags) = val;
        return val;
    }

    bool isIntegerSized()
    {
        return ((eeClass.layoutInfo.managedSize & 1) == 0 &&
            eeClass.layoutInfo.managedSize <= 8 && eeClass.layoutInfo.managedSize != 6);
    }

    uint typeDefRid()
    {
        return m_flags2 >> 8;
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
            return canonMethodTable.eeClass;

        return m_eeClass;
    }

    pragma(mangle, "MethodTable_canonMethodTable_get")
    extern (C) export @property MethodTable* canonMethodTable()
        scope return
    {
        if (relatedTypeKind != RelatedTypeKind.CanonMT)
            return &this;

        return cast(MethodTable*)(m_canonMT & ~UNION_MASK);
    }

    pragma(mangle, "MethodTable_eeClass_set")
    extern (C) export @property EEClass* eeClass(EEClass* val)
    {
        if (relatedTypeKind != RelatedTypeKind.EEClass)
            return canonMethodTable().eeClass = val;

        return m_eeClass = val;
    }

    pragma(mangle, "MethodTable_canonMethodTable_set")
    extern (C) export @property MethodTable* canonMethodTable(MethodTable* val)
    {
        if (relatedTypeKind == RelatedTypeKind.CanonMT)
        {
            m_canonMT = cast(size_t)val | cast(size_t)RelatedTypeKind.CanonMT;
            return val;
        }

        return null;
    }

    void setEEClassUnsafe(EEClass* newEEClass)
    {
        relatedTypeKind = RelatedTypeKind.EEClass;
        m_eeClass = newEEClass;
    }

    void setCanonMethodTableUnsafe(MethodTable* newCanonMethodTable)
    {
        relatedTypeKind = RelatedTypeKind.CanonMT;
        m_canonMT = cast(size_t)newCanonMethodTable | cast(size_t)RelatedTypeKind.CanonMT;
    }
}