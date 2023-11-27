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

    WriteableFlags writeableFlags;
    ptrdiff_t exposedClassObject;
}

public struct GuidInfo
{
public:
    UUID guid;
    bool generatedFromName;

    extern(C) export UUID getGuid()
    {
        return guid;
    }
    
    extern(C) export void setGuid(UUID val)
    {
        guid = val;
    }

    extern(C) export bool isGeneratedFromName()
    {
        return generatedFromName;
    }
    
    extern(C) export void setIsGeneratedFromName(bool val)
    {
        generatedFromName = val;
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
        TypeFlags typeFlags;
        mixin(bitfields!(
            ushort, "componentSize", 16,
            GenericFlags, "genericFlags", 16
        ));
    }
    // Base size of instance of this struct when allocated on the heap, including padding
    uint baseSize;
    InterfaceFlags interfaceFlags;
    // Class token if it fits into 16-bits. If this is (WORD)-1, the struct token is stored in the TokenOverflow optional member.
    HalfMDToken mdToken;
    ushort numVirtuals;
    ushort numInterfaces;
    /*
    #ifdef _DEBUG
    LPCUTF8         debug_m_szClassName;
    #endif //_DEBUG
    */
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

    extern(C) export RelatedTypeKind getRelatedTypeKind()
    {
        return cast(RelatedTypeKind)(unType & 3);
    }

    extern(C) export void setRelatedTypeKind(RelatedTypeKind val)
    {
        unType &= ~3;
        unType |= cast(uint)val & 3;
    }

    extern(C) export TypeFlags getTypeFlags()
    {
        return typeFlags;
    }

    extern(C) export void setTypeFlags(TypeFlags val)
    {
        typeFlags = val;
    }

    extern(C) export ushort getComponentSize()
    {
        if (!hasComponentSize())
            return 0;

        return componentSize;
    }

    extern(C) export void setComponentSize(ushort val)
    {
        if (!hasComponentSize())
            setHasComponentSize(true);

        componentSize = val;
    }

    extern(C) export GenericFlags getGenericFlags()
    {
        return genericFlags;
    }

    extern(C) export void setGenericFlags(GenericFlags val)
    {
        genericFlags = val;
    }

    extern(C) export bool isIntegerSized()
    {
        return ((eeClass.layoutInfo.managedSize & 1) == 0 && 
            eeClass.layoutInfo.managedSize <= 8 && eeClass.layoutInfo.managedSize != 6);
    }

    extern(C) export uint getBaseSize()
    {
        if (baseSize <= 0)
            return 1;

        return baseSize;
    }

    extern(C) export void setBaseSize(uint val)
    {
        baseSize = val;
    }

    extern(C) export InterfaceFlags getInterfaceFlags()
    {
        return interfaceFlags;
    }

    extern(C) export void setInterfaceFlags(InterfaceFlags val)
    {
        interfaceFlags = val;
    }

    extern(C) export HalfMDToken getMDToken()
    {
        return mdToken;
    }

    extern(C) export void setMDToken(HalfMDToken val)
    {
        mdToken = val;
    }

    extern(C) export bool hasTokenOverflow()
    {
        return mdToken == 0xFFFF;
    }

    extern(C) export ushort getNumVirtuals()
    {
        return numVirtuals;
    }

    extern(C) export void setNumVirtuals(ushort val)
    {
        numVirtuals = val;
    }

    extern(C) export ushort getNumInterfaces()
    {
        return numInterfaces;
    }

    extern(C) export void setNumInterfaces(ushort val)
    {
        numInterfaces = val;
    }

    extern(C) export MethodTable* getParentMethodTable()
    {
        return parentMethodTable;
    }

    extern(C) export void setParentMethodTable(MethodTable* val)
    {
        parentMethodTable = val;
    }

    extern(C) export Module* getCeeModule()
    {
        if (!hasComponentSize() && isNonGeneric())
            return ceemodule;

        return canonMethodTable.getModule();
    }

    extern(C) export void setCeeModule(Module* val)
    {
        ceemodule = val;
    }

    extern(C) export WriteableData* getWriteableData()
    {
        return writeableData;
    }

    extern(C) export void setWriteableData(WriteableData* val)
    {
        writeableData = val;
    }

    extern(C) export EEClass* getEEClass()
    {
        if (getRelatedTypeKind() != RelatedTypeKind.EEClass)
            return getCanonMethodTable();

        return eeClass;
    }

    extern(C) export void setEEClass(EEClass* val)
    {
        if (getRelatedTypeKind() != RelatedTypeKind.EEClass)
            setRelatedTypeKind(RelatedTypeKind.EEClass);

        eeClass = val;
    }

    extern(C) export MethodTable* getCanonMethodTable()
    {
        return canonMethodTable;
    }

    extern(C) export void setCanonMethodTable(MethodTable* val)
    {
        if (getRelatedTypeKind() != RelatedTypeKind.CanonMT)
            setRelatedTypeKind(RelatedTypeKind.CanonMT);

        canonMethodTable = val;
    }

    extern(C) export PerInstInfo* getPerInstInfo()
    {
        return perInstInfo;
    }

    extern(C) export void setPerInstInfo(PerInstInfo* val)
    {
        perInstInfo = val;
    }

    extern(C) export MethodTable* getElementMethodTable()
    {
        return elementMethodTable;
    }

    extern(C) export void setElementMethodTable(MethodTable* val)
    {
        elementMethodTable = val;
    }

    extern(C) export ubyte* getMultiPurposeSlot1()
    {
        return multiPurposeSlot1;
    }

    extern(C) export void setMultiPurposeSlot1(ubyte* val)
    {
        multiPurposeSlot1 = val;
    }

    extern(C) export MethodTable* getInterfaceMap()
    {
        return interfaceMap;
    }

    extern(C) export void setInterfaceMap(MethodTable* val)
    {
        interfaceMap = val;
    }

    extern(C) export ubyte* getMultiPurposeSlot2()
    {
        return multiPurposeSlot2;
    }

    extern(C) export void setMultiPurposeSlot2(ubyte* val)
    {
        multiPurposeSlot2 = val;
    }

    extern(C) export bool isNonDynamic()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.NonDynamic);
    }

    extern(C) export void setIsNonDynamic(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.StaticsMask, GenericFlags.NonDynamic, state);
    }

    extern(C) export bool isDynamic()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Dynamic);
    }

    extern(C) export void setIsDynamic(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.StaticsMask, GenericFlags.Dynamic, state);
    }

    extern(C) export bool hasGenerics()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.Generics);
    }

    extern(C) export void setHasGenerics(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.StaticsMask, GenericFlags.Generics, state);
    }

    extern(C) export bool hasCrossModuleGenerics()
    {
        return genericFlags.HasFlagMasked(GenericFlags.StaticsMask, GenericFlags.CrossModuleGenerics);
    }

    extern(C) export void setHasCrossModuleGenerics(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.StaticsMask, GenericFlags.CrossModuleGenerics, state);
    }

    extern(C) export bool isNotInPZM()
    {
        return genericFlags.HasFlag(GenericFlags.NotInPZM);
    }

    extern(C) export void setIsNotInPZM(bool state)
    {
        genericFlags.SetFlag(GenericFlags.NotInPZM, state);
    }

    extern(C) export bool isNonGeneric()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.NonGeneric);
    }

    extern(C) export void setIsNonGeneric(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.GenericsMask, GenericFlags.NonGeneric, state);
    }

    extern(C) export bool isGenericInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.GenericInst);
    }

    extern(C) export void setIsGenericInst(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.GenericsMask, GenericFlags.IsGenericInst, state);
    }

    extern(C) export bool isSharedInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.SharedInst);
    }

    extern(C) export void setIsSharedInst(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.GenericsMask, GenericFlags.IsSharedInst, state);
    }

    extern(C) export bool isTypicalInst()
    {
        return genericFlags.HasFlagMasked(GenericFlags.GenericsMask, GenericFlags.TypicalInst);
    }

    extern(C) export void setIsTypicalInst(bool state)
    {
        genericFlags.SetFlagMasked(GenericFlags.GenericsMask, GenericFlags.IsTypicalInst, state);
    }

    extern(C) export bool hasRemotingVtsInfo()
    {
        return genericFlags.HasFlag(GenericFlags.HasRemotingVtsInfo);
    }

    extern(C) export void setHasRemotingVtsInfo(bool state)
    {
        genericFlags.SetFlag(GenericFlags.HasRemotingVtsInfo, state);
    }

    extern(C) export bool hasVariance()
    {
        return genericFlags.HasFlag(GenericFlags.HasVariance);
    }

    extern(C) export void setHasVariance(bool state)
    {
        genericFlags.SetFlag(GenericFlags.HasVariance, state);
    }

    extern(C) export bool hasDefaultCtor()
    {
        return genericFlags.HasFlag(GenericFlags.HasDefaultCtor);
    }

    extern(C) export void setHasDefaultCtor(bool state)
    {
        genericFlags.SetFlag(GenericFlags.HasDefaultCtor, state);
    }

    extern(C) export bool hasPreciseInitCctors()
    {
        return genericFlags.HasFlag(GenericFlags.HasPreciseInitCctors);
    }

    extern(C) export void setHasPreciseInitCctors(bool state)
    {
        genericFlags.SetFlag(GenericFlags.HasPreciseInitCctors, state);
    }

    extern(C) export bool isHFA()
    {
        return genericFlags.HasFlag(GenericFlags.IsHFA);
    }

    extern(C) export void setIsHFA(bool state)
    {
        genericFlags.SetFlag(GenericFlags.IsHFA, state);
    }

    extern(C) export bool isRegStructPassed()
    {
        return genericFlags.HasFlag(GenericFlags.IsRegStructPassed);
    }

    extern(C) export void setIsRegStructPassed(bool state)
    {
        genericFlags.SetFlag(GenericFlags.IsRegStructPassed, state);
    }

    extern(C) export bool isByRefLike()
    {
       return genericFlags.HasFlag(GenericFlags.IsByRefLike);
    }

    extern(C) export void setIsByRefLike(bool state)
    {
        genericFlags.SetFlag(GenericFlags.IsByRefLike, state);
    }

    extern(C) export bool isClass()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Class);
    }

    extern(C) export void setIsClass(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.Class, state);
    }

    extern(C) export bool isMarshalByRef()
    {
        return typeFlags.HasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.MarshalByRef);
    }

    extern(C) export void setIsMarshalByRef(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.MarshalByRef, state);
    }

    extern(C) export bool isContextful()
    {
        return typeFlags.HasFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.Contextful);
    }

    extern(C) export void setIsContextful(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.MarshalByRefMask, TypeFlags.Contextful, state);
    }

    extern(C) export bool isValueType()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.ValueType);
    }

    extern(C) export void setIsNullable(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.ValueType, state);
    }

    extern(C) export bool isNullable()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Nullable);
    }

    extern(C) export void setIsNullable(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.Nullable, state);
    }

    extern(C) export bool isPrimitiveValueType()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.PrimitiveValueType);
    }

    extern(C) export void setIsPrimitiveValueType(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.PrimitiveValueType, state);
    }

    extern(C) export bool isTruePrimitive()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.TruePrimitive);
    }

    extern(C) export void setIsTruePrimitive(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.TruePrimitive, state);
    }

    extern(C) export bool isArray()
    {
        return typeFlags.HasFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array);
    }

    extern(C) export void setIsArray(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.ArrayMask, TypeFlags.Array, state);
    }

    extern(C) export bool isSzArray()
    {
        return typeFlags.HasFlag(TypeFlags.IfArrayThenSzArray);
    }

    extern(C) export void setIsSzArray(bool state)
    {
        typeFlags.SetFlag(TypeFlags.IfArrayThenSzArray, state);
    }

    extern(C) export bool isInterface()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.Interface);
    }

    extern(C) export void setIsInterface(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.Interface, state);
    }

    extern(C) export bool isTransparentProxy()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy);
    }

    extern(C) export void setIsTransparentProxy(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.TransparentProxy, state);
    }

    extern(C) export bool isAsyncPin()
    {
        return typeFlags.HasFlagMasked(TypeFlags.Mask, TypeFlags.AsyncPin);
    }

    extern(C) export void setIsAsyncPin(bool state)
    {
        typeFlags.SetFlagMasked(TypeFlags.Mask, TypeFlags.AsyncPin, state);
    }

    extern(C) export bool hasFinalizer()
    {
        return typeFlags.HasFlag(TypeFlags.HasFinalizer);
    }

    extern(C) export void setHasFinalizer(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasFinalizer, state);
    }

    extern(C) export bool isMarshalable()
    {
        return typeFlags.HasFlag(TypeFlags.IfNotInterfaceThenMarshalable);
    }

    extern(C) export void setIsMarshalable(bool state)
    {
        typeFlags.SetFlag(TypeFlags.IfNotInterfaceThenMarshalable, state);
    }

    extern(C) export bool hasGuidInfo()
    {
        return typeFlags.HasFlag(TypeFlags.IfInterfaceThenHasGuidInfo);
    }

    extern(C) export void setHasGuidInfo(bool state)
    {
        typeFlags.SetFlag(TypeFlags.IfInterfaceThenHasGuidInfo, state);
    }

    extern(C) export bool isICastable()
    {
        return typeFlags.HasFlag(TypeFlags.ICastable);
    }

    extern(C) export void setIsICastable(bool state)
    {
        typeFlags.SetFlag(TypeFlags.ICastable, state);
    }

    extern(C) export bool hasIndirectParent()
    {
        return typeFlags.HasFlag(TypeFlags.HasIndirectParent);
    }

    extern(C) export void setHasIndirectParent(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasIndirectParent, state);
    }

    extern(C) export bool containsPointers()
    {
        return typeFlags.HasFlag(TypeFlags.ContainsPointers);
    }

    extern(C) export void setContainsPointers(bool state)
    {
        typeFlags.SetFlag(TypeFlags.ContainsPointers, state);
    }

    extern(C) export bool hasTypeEquivalence()
    {
        return typeFlags.HasFlag(TypeFlags.HasTypeEquivalence);
    }

    extern(C) export void setHasTypeEquivalence(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasTypeEquivalence, state);
    }

    extern(C) export bool hasRCWPerTypeData()
    {
        return typeFlags.HasFlag(TypeFlags.HasRCWPerTypeData);
    }

    extern(C) export void setHasRCWPerTypeData(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasRCWPerTypeData, state);
    }

    extern(C) export bool hasCriticalFinalizer()
    {
        return typeFlags.HasFlag(TypeFlags.HasCriticalFinalizer);
    }

    extern(C) export void setHasCriticalFinalizer(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasCriticalFinalizer, state);
    }

    extern(C) export bool isCollectible()
    {
        return typeFlags.HasFlag(TypeFlags.Collectible);
    }

    extern(C) export void setIsCollectible(bool state)
    {
        typeFlags.SetFlag(TypeFlags.Collectible, state);
    }

    extern(C) export bool containsGenericVariables()
    {
        return typeFlags.HasFlag(TypeFlags.ContainsGenericVariables);
    }

    extern(C) export void setContainsGenericVariables(bool state)
    {
        typeFlags.SetFlag(TypeFlags.ContainsGenericVariables, state);
    }

    extern(C) export bool isComObject()
    {
        return typeFlags.HasFlag(TypeFlags.ComObject);
    }

    extern(C) export void setIsComObject(bool state)
    {
        typeFlags.SetFlag(TypeFlags.ComObject, state);
    }

    extern(C) export bool hasComponentSize()
    {
        return typeFlags.HasFlag(TypeFlags.HasComponentSize);
    }

    extern(C) export void setHasComponentSize(bool state)
    {
        typeFlags.SetFlag(TypeFlags.HasComponentSize, state);
    }

    extern(C) export bool isNonTrivialInterfaceCast()
    {
        return typeFlags.HasFlag(TypeFlags.NonTrivialInterfaceCast);
    }

    void setIsNonTrivialInterfaceCast(bool state)
    {
        typeFlags.SetFlag(TypeFlags.NonTrivialInterfaceCast, state);
    }

    extern(C) export bool hasModuleOverride()
    {
        return interfaceFlags.HasFlag(InterfaceFlags.HasModuleOverride);
    }

    extern(C) export void setHasModuleOverride(bool state)
    {
        interfaceFlags.SetFlag(InterfaceFlags.HasModuleOverride, state);
    }

    extern(C) export GCDesc* getGCDesc() const
        return scope
    {
        return cast(GCDesc*)&this;
    }
}