module vm.methodtable;

import std.uuid;
import std.bitmanip;
import vm.eeclass;
import vm.ceeload;
import vm.genericdict;
import flags;
import inc.corhdr;

public struct WriteableData
{
public:
    enum WriteableFlags : uint
    {
        RemotingConfigChecked     = 0x00000001,
        RequiresManagedActivation = 0x00000002,
        Unrestored = 0x00000004,
        // CriticalFinalizerObject derived type has had backout routines prepared
        CriticalTypePrepared = 0x00000008,
        HasApproxParent = 0x00000010,
        UnrestoredTypeKey = 0x00000020,
        IsNotFullyLoaded = 0x00000040,
        // struct and all depedencies loaded up to CLASS_LOADED_BUT_NOT_VERIFIED
        DependenciesLoaded = 0x00000080,
        SkipWinRTOverride = 0x00000100,

        CanCompareBitsOrUseFastGetHashCode = 0x00000200,
        HasCheckedCanCompareBitsOrUseFastGetHashCode = 0x00000400,

        NGENIsFixedUp            = 0x00010000, 
        // Set if we have cached the results of needs restore computation
        NGENIsNeedsRestoreCached = 0x00020000, 
        // The result of the needs restore computation
        NGENCachedNeedsRestore   = 0x00040000, 
        // Overriding interface that we should generate WinRT CCW stubs for.
        NGENOverridingInterface  = 0x00080000, 

        ParentMethodTablePointerValid = 0x40000000,
        HasInjectedInterfaceDuplicates = 0x80000000,
    }

    WriteableFlags writeableFlags;
    ptrdiff_t exposedClassObject;
}

public struct GuidInfo
{
public:
    UUID guid;
    bool generatedFromName;
}

public struct MethodTable
{
public:
    enum GenericFlags : ushort
    {
        // Statics
        StaticsMask = 0x00000006,
        NonDynamic = 0x00000000,
        Dynamic = 0x00000002,
        Generics = 0x00000004,
        CrossModuleGenerics = 0x00000006,
        IfGenericsThenCrossModule = 0x00000002,

        // PZM = Preferred Zap Module
        NotInPZM = 0x00000008,

        // Generics
        GenericsMask = 0x00000030,
        NonGeneric = 0x00000000,
        GenericInst = 0x00000010,
        SharedInst = 0x00000020,
        TypicalInst = 0x00000030,

        HasRemotingVtsInfo = 0x00000080,
        HasVariance = 0x00000100,
        HasDefaultCtor = 0x00000200,
        // Has static constructors that must be executed
        HasPreciseInitCctors = 0x00000400,
        // Homo-something Floating Arithmetic (vectors and such)
        IsHFA = 0x00000800,
        IsRegStructPassed = 0x00000800,
        IsByRefLike = 0x00001000
    }

    enum InterfaceFlags : ushort
    {
        MultipurposeSlotsMask = 0x001F,
        // Generic parameters
        HasPerInstInfo = 0x0001,
        // Has any interfaces
        HasInterfaceMap = 0x0002,
        HasDispatchMapSlot = 0x0004,
        HasNonVirtualSlots = 0x0008,
        HasModuleOverride = 0x0010,

        IsZapped = 0x0020,
        IsPreRestored = 0x0040,
        HasModuleDependencies = 0x0080,

        // ie: primitives
        IsIntrinsicType = 0x0100,
        RequiresDispatchTokenFat = 0x0200,
        // Has any static constructors
        HasCctor = 0x0400,
        // Is COM exposed
        HasCCWTemplate = 0x0800,
        RequiresAlign8 = 0x1000,
        HasBoxedRegularStatics = 0x2000,
        HasSingleNonVirtualSlot = 0x4000,
        // Declares methods that have type equivalent or type forwarded structures in their signature
        DependsOnEquivalentOrForwardedStructs = 0x8000
    }

    enum TypeFlags : uint
    {
        Mask = 0x000F0000,
        Class = 0x00000000,
        MarshalByRefMask = 0x000E0000,
        MarshalByRef = 0x00020000,
        // sub-category of MarshalByRef
        Contextful = 0x00030000,

        ValueType = 0x00040000,
        Nullable = 0x00050000,
        // sub-category of ValueType, Enum or primitive value type
        PrimitiveValueType = 0x00060000,
        // sub-category of ValueType, Primitive (ELEMENT_TYPE_I, etc.)
        TruePrimitive = 0x00070000,

        Array = 0x00080000,
        ArrayMask = 0x000C0000,
        IfArrayThenSzArray = 0x00020000,

        Interface = 0x000C0000,
        TransparentProxy = 0x000E0000,
        AsyncPin = 0x000F0000,

        // I chose to comment out this mask because it really isn't that useful
        //ElementTypeMask = 0x000E0000,

        HasFinalizer = 0x00100000,
        IfNotInterfaceThenMarshalable = 0x00200000,
        // Does the type has optional GuidInfo
        IfInterfaceThenHasGuidInfo = 0x00200000,
        ICastable = 0x00400000,
        HasIndirectParent = 0x00800000,
        ContainsPointers = 0x01000000,
        HasTypeEquivalence = 0x02000000,

        // has optional pointer to RCWPerTypeData
        HasRCWPerTypeData = 0x04000000,
        // finalizer must be run on Appdomain Unload
        HasCriticalFinalizer = 0x08000000,
        Collectible = 0x10000000,
        ContainsGenericVariables = 0x20000000,
        ComObject = 0x40000000,
        HasComponentSize = 0x80000000,
        NonTrivialInterfaceCast = Array | ComObject | ICastable
    }

    enum RelatedTypeKind
    {
        UNION_EECLASS      = 0,    //  0 - pointer to EEClass. This MethodTable is the canonical method table.
        UNION_INVALID      = 1,    //  1 - not used
        UNION_METHODTABLE  = 2,    //  2 - pointer to canonical MethodTable.
        UNION_INDIRECTION  = 3     //  3 - pointer to indirection cell that points to canonical MethodTable.
    }                              //      (used only if FEATURE_PREJIT is defined)

    union
    {
        union
        {
            TypeFlags typeFlags;
            mixin(bitfields!(
                ushort, "componentSize", 16,
                GenericFlags, "genericFlags", 16
            ));
        }
    }
    // Base size of instance of this struct when allocated on the heap, including padding
    uint baseSize;
    InterfaceFlags interfaceFlags;
    // Class token if it fits into 16-bits. If this is (WORD)-1, the struct token is stored in the TokenOverflow optional member.
    HalfMDToken mdToken;
    ushort numVirtuals;
    ushort numInterfaces;
    MethodTable* parentMethodTable;
    Module* ceemodule;
    WriteableData* writeableData;
    union
    {
        ubyte unType;
        EEClass* eeClass;
        MethodTable* canonMethodTable;
    }
    union
    {
        PerInstInfo* perInstInfo;
        MethodTable* elementMethodTable;
        ubyte* multiPurposeSlot1;
    }
    union
    {
        MethodTable* interfaceMap;
        ubyte* multiPurposeSlot2;
    }

    //                                                OPTIONAL FIELDS

    //                                 NAME                    TYPE                            GETTER                       \
        // Accessing this member efficiently is currently performance critical for static field accesses                \
        // in generic classes, so place it early in the list.                                                           \
    //    METHODTABLE_OPTIONAL_MEMBER(GenericsStaticsInfo,    GenericsStaticsInfo,            GetGenericsStaticsInfo      ) \
        // Accessed by interop, fairly frequently.                                                                      \
    //    METHODTABLE_COMINTEROP_OPTIONAL_MEMBERS()                                                                         \
        // Accessed during x-domain transition only, so place it late in the list.                                      \
    //    METHODTABLE_REMOTING_OPTIONAL_MEMBERS()                                                                           \
        // Accessed during certain generic type load operations only, so low priority                                   \
    //    METHODTABLE_OPTIONAL_MEMBER(ExtraInterfaceInfo,     TADDR,                          GetExtraInterfaceInfoPtr    ) \
        // TypeDef token for assemblies with more than 64k types. Never happens in real world.                          \
    //    METHODTABLE_OPTIONAL_MEMBER(TokenOverflow,          TADDR,                          GetTokenOverflowPtr         ) \

    RelatedTypeKind getRelatedTypeKind()
    {
        return cast(RelatedTypeKind)(unType & 3);
    }

    bool isIntegerSized()
    {
        return ((getBaseSize() & 1) == 0 && 
            getBaseSize() <= 8 && getBaseSize() != 6);
    }

    uint getBaseSize()
    {
        if (baseSize <= 0)
            return 1;

        return baseSize;
    }

    bool hasTokenOverflow()
    {
        return mdToken == 0xFFFF;
    }

    bool isNonDynamic()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.NonDynamic);
    }

    bool isDynamic()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Dynamic);
    }

    bool hasGenerics()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Generics);
    }

    bool hasCrossModuleGenerics()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.CrossModuleGenerics);
    }

    bool isNotInPZM()
    {
        return genericFlags.HasFlag(GenericFlags.NotInPZM);
    }

    bool isNonGeneric()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.NonGeneric);
    }

    bool isGenericInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.GenericInst);
    }

    bool isSharedInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.SharedInst);
    }

    bool isTypicalInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.TypicalInst);
    }

    bool hasRemotingVtsInfo()
    {
        return genericFlags.HasFlag(GenericFlags.HasRemotingVtsInfo);
    }

    bool hasVariance()
    {
        return genericFlags.HasFlag(GenericFlags.HasVariance);
    }

    bool hasDefaultCtor()
    {
        return genericFlags.HasFlag(GenericFlags.HasDefaultCtor);
    }

    bool hasPreciseInitCctors()
    {
        return genericFlags.HasFlag(GenericFlags.HasPreciseInitCctors);
    }

    bool isHFA()
    {
        return genericFlags.HasFlag(GenericFlags.IsHFA);
    }

    bool isRegStructPassed()
    {
        return genericFlags.HasFlag(GenericFlags.IsRegStructPassed);
    }

    bool isByRefLike()
    {
       return genericFlags.HasFlag(GenericFlags.IsByRefLike);
    }

    bool isClass()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Class);
    }

    bool isMarshalByRef()
    {
        return typeFlags.HasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.MarshalByRef);
    }

    bool isContextful()
    {
        return typeFlags.HasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.Contextful);
    }

    bool isValueType()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.ValueType);
    }

    bool isNullable()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Nullable);
    }

    bool isPrimitiveValueType()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.PrimitiveValueType);
    }

    bool isTruePrimitive()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.TruePrimitive);
    }

    bool isArray()
    {
        return typeFlags.HasFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array);
    }

    void setIsArray(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array, state);
    }

    bool isSzArray()
    {
        return typeFlags.HasFlag(TypeFlags.IfArrayThenSzArray);
    }

    void setIsSzArray(bool state)
    {
        typeFlags.SetFlag(TypeFlags.Array, state);
    }

    bool isInterface()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Interface);
    }

    void setIsInterface(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.Interface, state);
    }

    bool isTransparentProxy()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy);
    }

    void setIsTransparentProxy(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy, state);
    }

    bool isAsyncPin()
    {
        return (typeFlags & TypeFlags.Mask) == TypeFlags.AsyncPin;
    }

    void setIsAsyncPin(bool state)
    {
        if (state)
            typeFlags |= TypeFlags.AsyncPin;
        else
            typeFlags &= ~TypeFlags.AsyncPin;
    }

    bool hasFinalizer()
    {
        return (typeFlags & TypeFlags.Mask) == TypeFlags.HasFinalizer;
    }

    void setHasFinalizer(bool state)
    {
        if (state)
            typeFlags |= TypeFlags.HasFinalizer;
        else
            typeFlags &= ~TypeFlags.HasFinalizer;
    }

    bool isMarshalable()
    {
        return (typeFlags & TypeFlags.IfNotInterfaceThenMarshalable) != 0;
    }

    void setIsMarshalable(bool state)
    {
        if (state)
            typeFlags |= TypeFlags.IfNotInterfaceThenMarshalable;
        else
            typeFlags &= ~TypeFlags.IfNotInterfaceThenMarshalable;
    }

    bool hasGuidInfo()
    {
        return (typeFlags & TypeFlags.IfInterfaceThenHasGuidInfo) != 0;
    }

    void setHasGuidInfo(bool state)
    {
        if (state)
            typeFlags |= TypeFlags.IfInterfaceThenHasGuidInfo;
        else
            typeFlags &= ~TypeFlags.IfInterfaceThenHasGuidInfo;
    }
}