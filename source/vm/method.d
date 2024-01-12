module godwit.method;

import std.bitmanip;
import godwit.methodtable;
import godwit.methodimpl;
import godwit.llv.traits;

public struct MethodDescChunk
{
public:
final:
    @flags enum ChunkFlags : ushort
    {
        TokenRangeMask = 0x0FFF,
        HasCompactEntryPoints = 0x4000
    }

    MethodTable* m_declaringMethodTable;
    MethodDescChunk* m_nextChunk;
    ubyte m_size;
    ubyte m_count;
    ChunkFlags m_chunkFlags;
    // This is an array of MethodDesc.
    // MethodDescs are aligned to the nearest 8 byte boundary.
    align(8) MethodDesc m_methodDesc;

    mixin accessors;
}

// Equivalent to System.Runtime.MethodInfo.
public struct MethodDesc
{
public:
final:
    @flags enum MethodClassification : uint
    {
        IL,
        FCall,
        NDirect,
        EEImpl,
        Array,
        Instantiated,
        ComPlus,
        Dynamic,
        Count
    }

    @flags enum MethodProperties : ushort
    {
        HasNonVtableSlot = 0x0008,
        MethodImpl = 0x0010,
        HasNativeCodeSlot = 0x0020,
        EnCAddedMethod = 0x0040,
        Static = 0x0080,
        ValueTypeParametersWalked = 0x0100,
        ValueTypeParametersLoaded = 0x0200,
        Duplicate = 0x0400,
        DoesNotHaveEquivalentValuetypeParameters = 0x0800,
        RequiresCovariantReturnTypeChecking = 0x1000,
        NotInline = 0x2000,
        Synchronized = 0x4000,
        Intrinsic = 0x8000
    }

    @flags enum CodeFlags : ushort
    {
        TokenRemainderMask = 0x0FFF,
        HasStableEntryPoint = 0x1000,
        HasPrecode = 0x2000,
        IsUnboxingStub = 0x4000,
        IsEligibleForTieredCompilation = 0x8000
    }

    enum CallerGCMode
    {
        Unknown,
        Coop,
        // (e.g. UnmanagedCallersOnlyAttribute)
        Preemptive    
    }

    CodeFlags m_codeFlags;
    ubyte m_chunkIndex;
    ubyte m_methodIndex;
    ushort m_slotNumber;
    mixin(bitfields!(
        MethodClassification, "m_classification", 3,
        MethodProperties, "m_properties", 13
    ));

    mixin accessors;
}

public struct ILMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    void* m_fn;
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}

public struct InstantiatedMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    @flags enum InstantiationFlags
    {
        KindMask = 0x07,
        GenericMethodDefinition = 0x01,
        UnsharedMethodInstantiation = 0x02,
        SharedMethodInstantiation = 0x03,
        WrapperStubWithInstantiations = 0x04,
    }

    union
    {
        ubyte* m_dictLayout;
        MethodDesc* m_wrappedMethodDesc;
    }
    ubyte* m_perInstInfo;
    InstantiationFlags m_instFlags;
    int m_genericsCount;
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}

public struct ComPlusCallMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    void* m_comPlusCallInfo;
}

public struct StoredSigMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    void* m_sig;
    uint m_count;
    uint m_extendedFlags;

    mixin accessors;
}

public struct EEImplMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
final:
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}

public struct FCallMethodDesc
{
    MethodDesc methodDesc;

    alias methodDesc this;

public:
final:
    uint m_ecallId;
    uint padding;
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}

public struct DynamicMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
final:
    @flags enum ILStubType : uint
    {
        StubNotSet = 0,
        StubCLRToNativeInterop,
        StubCLRToCOMInterop,
        StubNativeToCLRInterop,
        StubCOMToCLRInterop,
        StubStructMarshalInterop,
        StubArrayOp,
        StubMulticastDelegate,
        StubWrapperDelegate,
        StubUnboxingIL,
        StubInstantiating,
        StubTailCallStoreArgs,
        StubTailCallCallTarget,
        StubVirtualStaticMethodDispatch,
        StubLast
    }

    @flags enum Flag : uint
    {
        FlagNone = 0x00000000,
        FlagPublic = 0x00000800,
        FlagStatic = 0x00001000,
        FlagRequiresCOM = 0x00002000,
        FlagIsLCGMethod = 0x00004000,
        FlagIsILStub = 0x00008000,
        FlagIsDelegate = 0x00010000,
        FlagIsCALLI = 0x00020000,
        FlagMask = 0x0003f800,
        StackArgSizeMask = 0xfffc0000, // native stack arg size for IL stubs
        ILStubTypeMask = ~(FlagMask | StackArgSizeMask)
    }

    char* m_methodName;
    ubyte* m_resolver;
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}

public struct ArrayMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;
}

public struct NDirectImportThunkGlue
{
public:
final:
    void* padding;
}

public struct NDirectWriteableData
{
public:
final:
    void* m_directTarget;

    mixin accessors;
}

public struct NDirectMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    @flags enum BindingFlags
    {
        EarlyBound = 0x0001, // IJW managed->unmanaged thunk. Standard [sysimport] stuff otherwise.
        DefaultDllImportSearchPathsIsCached = 0x0004, // set if we cache attribute value.
        IsMarshalingRequiredCached = 0x0010, // Set if we have cached the results of marshaling required computation
        CachedMarshalingRequired = 0x0020, // The result of the marshaling required computation
        NativeAnsi = 0x0040,
        LastError = 0x0080, // setLastError keyword specified
        NativeNoMangle = 0x0100, // nomangle keyword specified
        VarArgs = 0x0200,
        StdCall = 0x0400,
        ThisCall = 0x0800,
        IsQCall = 0x1000,
        DefaultDllImportSearchPathsStatus = 0x2000, // either method has custom attribute or not.
        NDirectPopulated = 0x8000, // Indicate if the NDirect has been fully populated.
    }

    char* m_entrypointName;
    union
    {
        char* m_libName;
        uint m_ecallId;
    }
    NDirectWriteableData* m_writeableData;
    NDirectImportThunkGlue* m_importThunkGlue;
    uint m_defaultDllSearchAttr;
    BindingFlags m_bindingFlags;
    // #ifdef FEATURE_COMINTEROP
    void* m_comPlusCallInfo;

    mixin accessors;
}