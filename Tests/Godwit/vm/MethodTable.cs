namespace Godwit.VM;

public class WriteableData : ICLR
{
    [Flags]
    public enum WriteableFlags : uint
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
}

public class GuidInfo : ICLR
{

}

public class MethodTable : ICLR
{
    [Flags]
    public enum GenericFlags : ushort
    {
        // Statics
        StaticsMask = 0x00000006,
        kNonDynamic = 0x00000000,
        kDynamic = 0x00000002,
        kGenerics = 0x00000004,
        kCrossModuleGenerics = 0x00000006,
        kIfGenericsThenCrossModule = 0x00000002,

        // PZM = Preferred Zap Module
        NotInPZM = 0x00000008,

        // Generics
        GenericsMask = 0x00000030,
        kNonGeneric = 0x00000000,
        kGenericInst = 0x00000010,
        kSharedInst = 0x00000020,
        kTypicalInst = 0x00000030,

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

    [Flags]
    public enum InterfaceFlags : ushort
    {
        MultipurposeSlotsMask = 0x001F,
        // Generic parameters
        kHasPerInstInfo = 0x0001,
        // Has any interfaces
        kHasInterfaceMap = 0x0002,
        kHasDispatchMapSlot = 0x0004,
        kHasNonVirtualSlots = 0x0008,
        kHasModuleOverride = 0x0010,

        IsZapped = 0x0020,
        IsPreRestored = 0x0040,
        HasModuleDependencies = 0x0080,

        // ie = primitives
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

    [Flags]
    public enum TypeFlags : uint
    {
        Mask = 0x000F0000,
        kClass = 0x00000000,
        kValueType = 0x00040000,
        kNullable = 0x00050000,
        // sub-category of ValueType, Enum or primitive value type
        kPrimitiveValueType = 0x00060000,
        // sub-category of ValueType, Primitive (ELEMENT_TYPE_I, etc.)
        kTruePrimitive = 0x00070000,
        kInterface = 0x000C0000,

        MarshalByRefMask = 0x000E0000,
        kMarshalByRef = 0x00020000,
        // sub-category of MarshalByRef
        kContextful = 0x00030000,

        ArrayMask = 0x000C0000,
        kArray = 0x00080000,
        IfArrayThenSzArray = 0x00020000,

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
        NonTrivialInterfaceCast = kArray | ComObject | ICastable
    }

    public enum RelatedTypeKind
    {
        EEClass = 0,    //  0 - pointer to EEClass. This MethodTable is the canonical method table.
        Invalid = 1,    //  1 - not used
        CanonMT = 2,    //  2 - pointer to canonical MethodTable.
        Indirection  = 3     //  3 - pointer to indirection cell that points to canonical MethodTable.
    }                              //      (used only if FEATURE_PREJIT is defined)
}