module vm.methodtable;

import std.uuid;
import std.bitmanip;
import vm.eeclass;
import vm.ceeload;
import vm.genericdict;
import flags;
import inc.corhdr;
import gc.gcdesc;

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

    WriteableFlags m_writeableFlags;
    ptrdiff_t m_exposedClassObject;

    @property WriteableFlags writeableFlags()
    {
        return m_writeableFlags;
    }

    @property WriteableFlags writeableFlags(WriteableFlags flags)
    {
        return m_writeableFlags = flags;
    }

    bool isRemotingConfigChecked()
    {
        return writeableFlags.hasFlag(WriteableFlags.RemotingConfigChecked);
    }

    bool isRequiresManagedActivation()
    {
        return writeableFlags.hasFlag(WriteableFlags.RequiresManagedActivation);
    }

    bool isUnrestored()
    {
        return writeableFlags.hasFlag(WriteableFlags.Unrestored);
    }

    bool isCriticalTypePrepared()
    {
        return writeableFlags.hasFlag(WriteableFlags.CriticalTypePrepared);
    }

    bool hasApproxParent()
    {
        return writeableFlags.hasFlag(WriteableFlags.HasApproxParent);
    }

    bool isUnrestoredTypeKey()
    {
        return writeableFlags.hasFlag(WriteableFlags.UnrestoredTypeKey);
    }

    bool isNotFullyLoaded()
    {
        return writeableFlags.hasFlag(WriteableFlags.IsNotFullyLoaded);
    }

    bool areDependenciesLoaded()
    {
        return writeableFlags.hasFlag(WriteableFlags.DependenciesLoaded);
    }

    bool isSkipWinRTOverride()
    {
        return writeableFlags.hasFlag(WriteableFlags.SkipWinRTOverride);
    }

    bool canCompareBitsOrUseFastGetHashCode()
    {
        return writeableFlags.hasFlag(WriteableFlags.CanCompareBitsOrUseFastGetHashCode);
    }

    bool hasCheckedCanCompareBitsOrUseFastGetHashCode()
    {
        return writeableFlags.hasFlag(WriteableFlags.HasCheckedCanCompareBitsOrUseFastGetHashCode);
    }

    bool isNGENIsFixedUp()
    {
        return writeableFlags.hasFlag(WriteableFlags.NGENIsFixedUp);
    }

    bool isNGENIsNeedsRestoreCached()
    {
        return writeableFlags.hasFlag(WriteableFlags.NGENIsNeedsRestoreCached);
    }

    bool isNGENCachedNeedsRestore()
    {
        return writeableFlags.hasFlag(WriteableFlags.NGENCachedNeedsRestore);
    }

    bool isNGENOverridingInterface()
    {
        return writeableFlags.hasFlag(WriteableFlags.NGENOverridingInterface);
    }

    bool isParentMethodTablePointerValid()
    {
        return writeableFlags.hasFlag(WriteableFlags.ParentMethodTablePointerValid);
    }

    bool hasInjectedInterfaceDuplicates()
    {
        return writeableFlags.hasFlag(WriteableFlags.HasInjectedInterfaceDuplicates);
    }

    void setIsRemotingConfigChecked(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.RemotingConfigChecked, state);
    }

    void setIsRequiresManagedActivation(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.RequiresManagedActivation, state);
    }

    void setIsUnrestored(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.Unrestored, state);
    }

    void setIsCriticalTypePrepared(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.CriticalTypePrepared, state);
    }

    void setHasApproxParent(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.HasApproxParent, state);
    }

    void setIsUnrestoredTypeKey(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.UnrestoredTypeKey, state);
    }

    void setIsNotFullyLoaded(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.IsNotFullyLoaded, state);
    }

    void setAreDependenciesLoaded(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.DependenciesLoaded, state);
    }

    void setIsSkipWinRTOverride(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.SkipWinRTOverride, state);
    }

    void setCanCompareBitsOrUseFastGetHashCode(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.CanCompareBitsOrUseFastGetHashCode, state);
    }

    void setHasCheckedCanCompareBitsOrUseFastGetHashCode(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.HasCheckedCanCompareBitsOrUseFastGetHashCode, state);
    }

    void setIsNGENIsFixedUp(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.NGENIsFixedUp, state);
    }

    void setIsNGENIsNeedsRestoreCached(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.NGENIsNeedsRestoreCached, state);
    }

    void setIsNGENCachedNeedsRestore(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.NGENCachedNeedsRestore, state);
    }

    void setIsNGENOverridingInterface(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.NGENOverridingInterface, state);
    }

    void setIsParentMethodTablePointerValid(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.ParentMethodTablePointerValid, state);
    }

    void setHasInjectedInterfaceDuplicates(bool state)
    {
        writeableFlags.setFlag(WriteableFlags.HasInjectedInterfaceDuplicates, state);
    }

    @property ptrdiff_t exposedClassObject()
    {
        return m_exposedClassObject;
    }

    @property qptrdiff_t exposedClassObject(ptrdiff_t value)
    {
        return m_exposedClassObject = value;
    }
}

public struct GuidInfo
{
public:
    UUID m_guid;
    bool m_generatedFromName;

    @property UUID guid()
    {
        return m_guid;
    }

    @property UUID guid(UUID newGuid)
    {
        return m_guid = newGuid;
    }

    @property bool isGeneratedFromName()
    {
        return m_generatedFromName;
    }

    @property bool isGeneratedFromName(bool state)
    {
        return m_generatedFromName = state;
    }
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
        EEClass = 0,    //  0 - pointer to EEClass. This MethodTable is the canonical method table.
        Invalid = 1,    //  1 - not used
        CanonMT = 2,    //  2 - pointer to canonical MethodTable.
        Indirection  = 3     //  3 - pointer to indirection cell that points to canonical MethodTable.
    }                              //      (used only if FEATURE_PREJIT is defined)

    union
    {
        TypeFlags m_typeFlags;
        mixin(bitfields!(
            ushort, "m_componentSize", 16,
            GenericFlags, "m_genericFlags", 16
        ));
    }
    // Base size of instance of this struct when allocated on the heap, including padding
    uint m_baseSize;
    InterfaceFlags m_interfaceFlags;
    // Class token if it fits into 16-bits. If this is (WORD)-1, the struct token is stored in the TokenOverflow optional member.
    HalfMDToken m_mdToken;
    ushort m_numVirtuals;
    ushort m_numInterfaces;
    /*
    #ifdef _DEBUG
    LPCUTF8         debug_m_szClassName;
    #endif //_DEBUG
    */
    MethodTable* m_parentMethodTable;
    Module* m_ceemodule;
    WriteableData* m_writeableData;
    union
    {
        ubyte m_unType;
        EEClass* m_eeClass;
        MethodTable* m_canonMethodTable;
    }
    union
    {
        PerInstInfo* m_perInstInfo;
        MethodTable* m_elementMethodTable;
        ubyte* m_multiPurposeSlot1;
    }
    union
    {
        MethodTable* m_interfaceMap;
        ubyte* m_multiPurposeSlot2;
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

    void setRelatedTypeKind(RelatedTypeKind newTypeKind)
    {
        // Assuming unType is an integer type
        unType = (unType & ~3) | cast(ubyte)newTypeKind;
    }

    bool isIntegerSized()
    {
        return ((eeClass.layoutInfo.managedSize & 1) == 0 && 
            eeClass.layoutInfo.managedSize <= 8 && eeClass.layoutInfo.managedSize != 6);
    }

    TypeFlags typeFlags()
    {
        return m_typeFlags;
    }
    uint baseSize()
    {
        if (m_baseSize <= 0)
            return 1;

        return m_baseSize;
    }

    bool hasTokenOverflow()
    {
        return mdToken == 0xFFFF;
    }

    bool isNonDynamic()
    {
        return genericFlags.hasFlagMasked(GenericFlags.StaticsMask, GenericFlags.NonDynamic);
    }

    bool isDynamic()
    {
        return genericFlags.hasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Dynamic);
    }

    bool hasGenerics()
    {
        return genericFlags.hasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Generics);
    }

    bool hasCrossModuleGenerics()
    {
        return genericFlags.hasFlagMasked(GenericFlags.StaticsMask, GenericFlags.CrossModuleGenerics);
    }

    bool isNotInPZM()
    {
        return genericFlags.hasFlag(GenericFlags.NotInPZM);
    }

    bool isNonGeneric()
    {
        return genericFlags.hasFlagMasked(GenericFlags.GenericsMask, GenericFlags.NonGeneric);
    }

    bool isGenericInst()
    {
        return genericFlags.hasFlagMasked(GenericFlags.GenericsMask, GenericFlags.GenericInst);
    }

    bool isSharedInst()
    {
        return genericFlags.hasFlagMasked(GenericFlags.GenericsMask, GenericFlags.SharedInst);
    }

    bool isTypicalInst()
    {
        return genericFlags.hasFlagMasked(GenericFlags.GenericsMask, GenericFlags.TypicalInst);
    }

    bool hasRemotingVtsInfo()
    {
        return genericFlags.hasFlag(GenericFlags.HasRemotingVtsInfo);
    }

    bool hasVariance()
    {
        return genericFlags.hasFlag(GenericFlags.HasVariance);
    }

    bool hasDefaultCtor()
    {
        return genericFlags.hasFlag(GenericFlags.HasDefaultCtor);
    }

    bool hasPreciseInitCctors()
    {
        return genericFlags.hasFlag(GenericFlags.HasPreciseInitCctors);
    }

    bool isHFA()
    {
        return genericFlags.hasFlag(GenericFlags.IsHFA);
    }

    bool isRegStructPassed()
    {
        return genericFlags.hasFlag(GenericFlags.IsRegStructPassed);
    }

    bool isByRefLike()
    {
       return genericFlags.hasFlag(GenericFlags.IsByRefLike);
    }

    bool isClass()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.Class);
    }

    bool isMarshalByRef()
    {
        return typeFlags.hasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.MarshalByRef);
    }

    bool isContextful()
    {
        return typeFlags.hasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.Contextful);
    }

    bool isValueType()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.ValueType);
    }

    bool isNullable()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.Nullable);
    }

    bool isPrimitiveValueType()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.PrimitiveValueType);
    }

    bool isTruePrimitive()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.TruePrimitive);
    }

    void setBaseSize(uint newSize)
    {
        baseSize = newSize <= 0 ? 1 : newSize;
    }

    void setIsNonDynamic(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.StaticsMask, GenericFlags.NonDynamic, state);
    }

    void setIsDynamic(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.StaticsMask, GenericFlags.Dynamic, state);
    }

    void setHasGenerics(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.StaticsMask, GenericFlags.Generics, state);
    }

    void setHasCrossModuleGenerics(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.StaticsMask, GenericFlags.CrossModuleGenerics, state);
    }

    void setIsNotInPZM(bool state)
    {
        genericFlags.setFlag(GenericFlags.NotInPZM, state);
    }

    void setIsNonGeneric(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.GenericsMask, GenericFlags.NonGeneric, state);
    }

    void setIsGenericInst(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.GenericsMask, GenericFlags.GenericInst, state);
    }

    void setIsSharedInst(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.GenericsMask, GenericFlags.SharedInst, state);
    }

    void setIsTypicalInst(bool state)
    {
        genericFlags.setFlagMasked(GenericFlags.GenericsMask, GenericFlags.TypicalInst, state);
    }

    void setHasRemotingVtsInfo(bool state)
    {
        genericFlags.setFlag(GenericFlags.HasRemotingVtsInfo, state);
    }

    void setHasVariance(bool state)
    {
        genericFlags.setFlag(GenericFlags.HasVariance, state);
    }

    void setHasDefaultCtor(bool state)
    {
        genericFlags.setFlag(GenericFlags.HasDefaultCtor, state);
    }

    void setHasPreciseInitCctors(bool state)
    {
        genericFlags.setFlag(GenericFlags.HasPreciseInitCctors, state);
    }

    void setIsHFA(bool state)
    {
        genericFlags.setFlag(GenericFlags.IsHFA, state);
    }

    void setIsRegStructPassed(bool state)
    {
        genericFlags.setFlag(GenericFlags.IsRegStructPassed, state);
    }

    void setIsByRefLike(bool state)
    {
        genericFlags.setFlag(GenericFlags.IsByRefLike, state);
    }

    void setIsClass(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.Class, state);
    }

    void setIsMarshalByRef(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.MarshalByRef, state);
    }

    void setIsContextful(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.Contextful, state);
    }

    void setIsValueType(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.ValueType, state);
    }

    void setIsNullable(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.Nullable, state);
    }

    void setIsPrimitiveValueType(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.PrimitiveValueType, state);
    }

    void setIsTruePrimitive(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.TruePrimitive, state);
    }

    bool isArray()
    {
        return typeFlags.hasFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array);
    }

    void setIsArray(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array, state);
    }

    bool isSzArray()
    {
        return typeFlags.hasFlag(TypeFlags.IfArrayThenSzArray);
    }

    void setIsSzArray(bool state)
    {
        typeFlags.setFlag(TypeFlags.IfArrayThenSzArray, state);
    }

    bool isInterface()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.Interface);
    }

    void setIsInterface(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.Interface, state);
    }

    bool isTransparentProxy()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy);
    }

    void setIsTransparentProxy(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy, state);
    }

    bool isAsyncPin()
    {
        return typeFlags.hasFlagMasked(TypeFlags.Mask, TypeFlags.AsyncPin);
    }

    void setIsAsyncPin(bool state)
    {
        typeFlags.setFlagMasked(TypeFlags.Mask, TypeFlags.AsyncPin, state);
    }

    bool hasFinalizer()
    {
        return typeFlags.hasFlag(TypeFlags.HasFinalizer);
    }

    void setHasFinalizer(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasFinalizer, state);
    }

    bool isMarshalable()
    {
        return typeFlags.hasFlag(TypeFlags.IfNotInterfaceThenMarshalable);
    }

    void setIsMarshalable(bool state)
    {
        typeFlags.setFlag(TypeFlags.IfNotInterfaceThenMarshalable, state);
    }

    bool hasGuidInfo()
    {
        return typeFlags.hasFlag(TypeFlags.IfInterfaceThenHasGuidInfo);
    }

    void setHasGuidInfo(bool state)
    {
        typeFlags.setFlag(TypeFlags.IfInterfaceThenHasGuidInfo, state);
    }

    bool isICastable()
    {
        return typeFlags.hasFlag(TypeFlags.ICastable);
    }

    void setIsICastable(bool state)
    {
        typeFlags.setFlag(TypeFlags.ICastable, state);
    }

    bool hasIndirectParent()
    {
        return typeFlags.hasFlag(TypeFlags.HasIndirectParent);
    }

    void setHasIndirectParent(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasIndirectParent, state);
    }

    bool containsPointers()
    {
        return typeFlags.hasFlag(TypeFlags.ContainsPointers);
    }

    void setContainsPointers(bool state)
    {
        typeFlags.setFlag(TypeFlags.ContainsPointers, state);
    }

    bool hasTypeEquivalence()
    {
        return typeFlags.hasFlag(TypeFlags.HasTypeEquivalence);
    }

    void setHasTypeEquivalence(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasTypeEquivalence, state);
    }

    bool hasRCWPerTypeData()
    {
        return typeFlags.hasFlag(TypeFlags.HasRCWPerTypeData);
    }

    void setHasRCWPerTypeData(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasRCWPerTypeData, state);
    }

    bool hasCriticalFinalizer()
    {
        return typeFlags.hasFlag(TypeFlags.HasCriticalFinalizer);
    }

    void setHasCriticalFinalizer(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasCriticalFinalizer, state);
    }

    bool isCollectible()
    {
        return typeFlags.hasFlag(TypeFlags.Collectible);
    }

    void setIsCollectible(bool state)
    {
        typeFlags.setFlag(TypeFlags.Collectible, state);
    }

    bool containsGenericVariables()
    {
        return typeFlags.hasFlag(TypeFlags.ContainsGenericVariables);
    }

    void setContainsGenericVariables(bool state)
    {
        typeFlags.setFlag(TypeFlags.ContainsGenericVariables, state);
    }

    bool isComObject()
    {
        return typeFlags.hasFlag(TypeFlags.ComObject);
    }

    void setIsComObject(bool state)
    {
        typeFlags.setFlag(TypeFlags.ComObject, state);
    }

    bool hasComponentSize()
    {
        return typeFlags.hasFlag(TypeFlags.HasComponentSize);
    }

    void setHasComponentSize(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasComponentSize, state);
    }

    bool isNonTrivialInterfaceCast()
    {
        return typeFlags.hasFlag(TypeFlags.NonTrivialInterfaceCast);
    }

    void setIsNonTrivialInterfaceCast(bool state)
    {
        typeFlags.setFlag(TypeFlags.NonTrivialInterfaceCast, state);
    }

    bool hasModuleOverride()
    {
        return interfaceFlags.hasFlag(InterfaceFlags.HasModuleOverride);
    }

    void setHasModuleOverride(bool state)
    {
        interfaceFlags.setFlag(InterfaceFlags.HasModuleOverride, state);
    }

    GCDesc* getGCDesc() const
        scope return
    {
        return cast(GCDesc*)&this;
    }

    Module* getModule()
    {
        if (!hasComponentSize() && isNonGeneric())
            return ceemodule;

        return getCanonMethodTable().getModule();
    }

    void setModule(Module* newModule)
    {
        if (!hasComponentSize() && isNonGeneric())
            ceemodule = newModule;

        getCanonMethodTable().setModule(newModule);
    }

    WriteableData* getWriteableData()
    {
        return writeableData;
    }

    EEClass* getEEClass()
    {
        if (getRelatedTypeKind() != RelatedTypeKind.EEClass)
            return getCanonMethodTable().getEEClass();

        return eeClass;
    }

    MethodTable* getCanonMethodTable()
        scope return
    {
        if (getRelatedTypeKind() != RelatedTypeKind.CanonMT)
            return &this;

        return canonMethodTable;
    }

    PerInstInfo* getPerInstInfo()
    {
        return perInstInfo;
    }

    MethodTable* getElementMethodTable()
    {
        return elementMethodTable;
    }

    ubyte* getMultiPurposeSlot1()
    {
        return multiPurposeSlot1;
    }

    MethodTable* getInterfaceMap()
    {
        return interfaceMap;
    }

    ubyte* getMultiPurposeSlot2()
    {
        return multiPurposeSlot2;
    }

    void setWriteableData(WriteableData* newData)
    {
        writeableData = newData;
    }

    void setEEClass(EEClass* newEEClass)
    {
        if (getRelatedTypeKind() != RelatedTypeKind.EEClass)
            getCanonMethodTable().setEEClass(newEEClass);
        else
            eeClass = newEEClass;
    }

    void setCanonMethodTable(MethodTable* newCanonMethodTable)
    {
        if (getRelatedTypeKind() == RelatedTypeKind.CanonMT)
            canonMethodTable = newCanonMethodTable;
    }

    void setEEClassUnsafe(EEClass* newEEClass)
    {
        setRelatedTypeKind(RelatedTypeKind.EEClass);
        eeClass = newEEClass;
    }

    void setCanonMethodTableUnsafe(MethodTable* newCanonMethodTable)
    {
        setRelatedTypeKind(RelatedTypeKind.CanonMT);
        canonMethodTable = newCanonMethodTable;
    }

    void setPerInstInfo(PerInstInfo* newPerInstInfo)
    {
        perInstInfo = newPerInstInfo;
    }

    void setElementMethodTable(MethodTable* newElementMethodTable)
    {
        elementMethodTable = newElementMethodTable;
    }

    void setMultiPurposeSlot1(ubyte* newData)
    {
        multiPurposeSlot1 = newData;
    }

    void setInterfaceMap(MethodTable* newInterfaceMap)
    {
        interfaceMap = newInterfaceMap;
    }

    void setMultiPurposeSlot2(ubyte* newData)
    {
        multiPurposeSlot2 = newData;
    }
}