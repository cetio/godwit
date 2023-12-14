module vm.method;

import std.bitmanip;
import vm.methodtable;
import vm.methodimpl;
import flags;

extern (C) export int GetBaseSize(MethodDesc* pmd)
{
    return pmd.getBaseSize();
}

extern (C) export int GetOptionalSize(MethodDesc* pmd)
{
    return pmd.getOptionalSize();
}

public struct MethodDescChunk
{
public:
    enum ChunkFlags : ushort
    {
        TokenRangeMask = 0x0FFF,
        HasCompactEntryPoints = 0x4000
    }

    MethodTable* declaringMethodTable;
    MethodDescChunk* nextChunk;
    ubyte size;
    ubyte count;
    ChunkFlags chunkFlags;
    // This is an array of MethodDesc.
    // MethodDescs are aligned to the nearest 8 byte boundary.
    align(8) MethodDesc methodDesc;
}

// Equivalent to System.Runtime.MethodInfo.
public struct MethodDesc
{
public:
    public enum MethodClassification : uint
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

    public enum MethodProperties : ushort
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

    public enum CodeFlags : ushort
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
    };

    CodeFlags codeFlags;
    ubyte chunkIndex;
    ubyte methodIndex;
    ushort slotNumber;
    mixin(bitfields!(
        MethodClassification, "classification", 3,
        MethodProperties, "properties", 13
    ));

    public int getBaseSize()
    {
        if (isIL())
            return ILMethodDesc.sizeof;

        if (isFCall())
            return FCallMethodDesc.sizeof;

        if (isNDirect())
            return NDirectMethodDesc.sizeof;

        if (isEEImpl())
            return EEImplMethodDesc.sizeof;

        if (isInstantiated())
            return InstantiatedMethodDesc.sizeof;

        if (isComPlus())
            return ComPlusCallMethodDesc.sizeof;

        return DynamicMethodDesc.sizeof;
    }

    public int getOptionalSize()
    {
        int size = 0;

        if (hasNonVtableSlot())
            size += size_t.sizeof;

        if (hasMethodImpl())
            size += MethodImpl.sizeof;

        if (hasNativeCodeSlot())
            size += size_t.sizeof;

        return size;
    }

    bool isIL()
    {
        return classification == MethodClassification.IL;
    }

    bool isFCall()
    {
        return classification == MethodClassification.FCall;
    }

    bool isNDirect()
    {
        return classification == MethodClassification.NDirect;
    }

    bool isEEImpl()
    {
        return classification == MethodClassification.EEImpl;
    }

    bool isInstantiated()
    {
        return classification == MethodClassification.Instantiated;
    }

    bool isComPlus()
    {
        return classification == MethodClassification.ComPlus;
    }

    bool isDynamic()
    {
        return classification == MethodClassification.Dynamic;
    }

    bool hasNonVtableSlot()
    {
        return properties.hasFlag(MethodProperties.HasNonVtableSlot);
    }

    bool hasMethodImpl()
    {
        return properties.hasFlag(MethodProperties.MethodImpl);
    }

    bool hasNativeCodeSlot()
    {
        return properties.hasFlag(MethodProperties.HasNativeCodeSlot);
    }
}

public struct ILMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
    void* fnptr;
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}

public struct InstantiatedMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
    enum InstantiationFlags
    {
        KindMask = 0x07,
        GenericMethodDefinition = 0x01,
        UnsharedMethodInstantiation = 0x02,
        SharedMethodInstantiation = 0x03,
        WrapperStubWithInstantiations = 0x04,
    };

    union
    {
        ubyte* dictLayout;
        MethodDesc* wrappedMethodDesc;
    };
    ubyte* perInstInfo;
    InstantiationFlags instFlags;
    int genericsCount;
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}

public struct ComPlusCallMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
    void* comPlusCallInfo;
}

public struct StoredSigMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
    void* sig;
    uint count;
    uint extendedFlags;
}

public struct EEImplMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}

public struct FCallMethodDesc
{
    MethodDesc methodDesc;

    alias methodDesc this;

public:
    uint ecallId;
    uint padding;
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}

public struct DynamicMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
    enum ILStubType : uint
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
    };

    enum Flag : uint
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
    };

    char* methodName;
    ubyte* resolver;
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}

public struct ArrayMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;
}

public struct NDirectImportThunkGlue
{
public:
    void* padding;
}

public struct NDirectWriteableData
{
public:
    void* directTarget;
}

public struct NDirectMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
    enum BindingFlags
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
    };

    char* entrypointName;
    union
    {
        char* libName;
        uint ecallId;
    }
    NDirectWriteableData* writeableData;
    NDirectImportThunkGlue* importThunkGlue;
    uint defaultDllSearchAttr;
    BindingFlags bindingFlags;
    // #ifdef FEATURE_COMINTEROP
    void* comPlusCallInfo;
}