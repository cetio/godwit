module godwit.backend.vm.method;

import std.bitmanip;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.methodimpl;
import godwit.backend.metadata;
import godwit.backend.vm.genericdict;
import godwit.impl;

public struct MethodDescChunk
{
public:
final:
    enum ChunkFlags : ushort
    {
        TokenRangeMask = 0x03FF,
        IsZapped = 0x8000,
    }

    MethodTable* methodTable;
    MethodDescChunk* next;
    /// The size of this chunk minus 1 (in multiples of MethodDesc.ALIGNMENT)
    ubyte size;
    /// The number of MethodDescs in this chunk minus 1
    ubyte count;
    ChunkFlags flagsAndTokenRange;

    ushort tokenRange()
    {
        return cast(ushort)(flagsAndTokenRange & ChunkFlags.TokenRangeMask);
    }

    MethodDesc*[] methods()
        scope return
    {
        MethodDesc*[] ret;
        MethodDesc* md = cast(MethodDesc*)(cast(ubyte*)&this + MethodDescChunk.sizeof);
        foreach (i; 0..(count + 1))
        {
            ret ~= md;
            md = cast(MethodDesc*)(cast(ubyte*)md + md.sizeOf);
        }
        return ret;
    }

}

/// Equivalent to System.Runtime.MethodInfo.
public struct MethodDesc
{
public:
final:
    enum Classification : uint
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

    enum Properties : ushort
    {
        HasNonVtableSlot = 0x0008,
        MethodImpl = 0x0010,
        HasNativeCodeSlot = 0x0020,
        Static = 0x0080,
        Duplicate = 0x0400,
        NotInline = 0x2000,
        Synchronized = 0x4000,
    }

    enum Flags3 : ushort
    {
        TokenRemainderMask = 0x3FFF,
        HasForwardedValuetypeParameter = 0x4000,
        ValueTypeParametersWalked = 0x4000,
        DoesNotHaveEquivalentValuetypeParameters = 0x8000,
    }

    enum Flags2 : ubyte
    {
        HasStableEntryPoint = 0x01,
        HasPrecode = 0x02,
        IsUnboxingStub = 0x04,
        IsJitIntrinsic = 0x10,
        IsEligibleForTieredCompilation = 0x20,
        RequiresCovariantReturnTypeChecking = 0x40,
    }

    enum CallerGCMode
    {
        Unknown,
        Coop,
        Preemptive
    }

    enum : size_t
    {
        ALIGNMENT_SHIFT = 3,
        ALIGNMENT = 1 << ALIGNMENT_SHIFT,
        ALIGNMENT_MASK = ALIGNMENT - 1,
    }

    ushort flags3AndTokenRemainder;
    ubyte chunkIndex;
    ubyte flags2;
    ushort slotNumber;
    ushort flags;

    static if (DEBUG)
    {
        const(char)* debugMethodName;
        const(char)* debugClassName;
        const(char)* debugMethodSignature;
        MethodTable* debugMethodTable;
        void* gcCover;
    }

    Classification classification()
    {
        return cast(Classification)(flags & 0x0007);
    }

    uint baseSize()
    {
        uint ret;
        switch (classification)
        {
            case Classification.IL:
                ret = cast(uint)MethodDesc.sizeof;
                break;
            case Classification.FCall:
                ret = cast(uint)FCallMethodDesc.sizeof;
                break;
            case Classification.NDirect:
                ret = cast(uint)NDirectMethodDesc.sizeof;
                break;
            case Classification.EEImpl:
                ret = cast(uint)EEImplMethodDesc.sizeof;
                break;
            case Classification.Array:
                ret = cast(uint)ArrayMethodDesc.sizeof;
                break;
            case Classification.Instantiated:
                ret = cast(uint)InstantiatedMethodDesc.sizeof;
                break;
            case Classification.Dynamic:
                ret = cast(uint)DynamicMethodDesc.sizeof;
                break;
            default:
                break;
        }
        return ret;
    }

    uint sizeOf()
    {
        uint ret = baseSize;

        static if (COM_INTEROP)
            ret += cast(uint)ComPlusCallInfo.sizeof;

        if ((flags & Properties.HasNonVtableSlot) != 0)
            ret += size_t.sizeof;

        if ((flags & Properties.MethodImpl) != 0)
            ret += cast(uint)MethodImpl.sizeof;

        if ((flags & Properties.HasNativeCodeSlot) != 0)
            ret += size_t.sizeof;

        return ret;
    }

    int methodDescChunkIndex()
    {
        return chunkIndex;
    }

    MethodDescChunk* methodDescChunk()
        scope return
    {
        return cast(MethodDescChunk*)(cast(ubyte*)&this -
            (MethodDescChunk.sizeof + (methodDescChunkIndex * ALIGNMENT)));
    }

    MethodDef token()
    {
        ushort range = methodDescChunk.tokenRange;
        ushort rem = flags3AndTokenRemainder & Flags3.TokenRemainderMask;
        return (range << 14) | rem | CorTokenType.MethodDef;
    }

}

public struct InstantiatedMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    enum InstantiationFlags : ushort
    {
        KindMask = 0x07,
        GenericMethodDefinition = 0x01,
        UnsharedMethodInstantiation = 0x02,
        SharedMethodInstantiation = 0x03,
        WrapperStubWithInstantiations = 0x04,
    }

    union
    {
        void* dictLayout;
        MethodDesc* wrappedMethodDesc;
    }
    Dictionary* perInstInfo;
    ushort flags2;
    ushort numGenericArgs;

}

public struct ComPlusCallMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
}

public struct MethodDescCodeData
{
public:
final:
    size_t temporaryEntryPoint;

}

public struct AsyncMethodData
{
public:
final:
    uint flags;
    void* sig;
    uint sigLen;

}

public struct StoredSigMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    size_t sig;
    uint count;
    uint extendedFlags;

}

public struct EEImplMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
final:
}

public struct FCallMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    uint ecallId;

    static if (HOST_x64)
    {
        uint padding;
    }

}

public struct DynamicMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;

public:
final:
    enum ILStubType : uint
    {
        StubNotSet = 0,
        StubPInvoke = 1,
        StubPInvokeDelegate = 2,
        StubPInvokeCalli = 3,
        StubPInvokeVarArg = 4,
        StubReversePInvoke = 5,
        StubCLRToCOMInterop = 6,
        StubCOMToCLRInterop = 7,
        StubStructMarshalInterop = 8,
        StubArrayOp = 9,
        StubMulticastDelegate = 10,
        StubWrapperDelegate = 11,
        StubUnboxingIL = 12,
        StubInstantiating = 13,
        StubTailCallStoreArgs = 14,
        StubTailCallCallTarget = 15,
        StubVirtualStaticMethodDispatch = 16,
        StubDelegateShuffleThunk = 17,
        StubDelegateInvokeMethod = 18,
        StubAsyncResume = 19,
        StubCLRToCOMEvent = 20,
        StubLast = 21
    }

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
        StackArgSizeMask = 0xfffc0000,
        ILStubTypeMask = ~(FlagMask | StackArgSizeMask)
    }

    const(char)* methodName;
    void* resolver;

}

public struct ArrayMethodDesc
{
    StoredSigMethodDesc storedSigMethodDesc;
    alias storedSigMethodDesc this;
}

public struct NDirectWriteableData
{
public:
final:
    void* directTarget;

}

public struct NDirectMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    enum BindingFlags
    {
        EarlyBound = 0x0001,
        DefaultDllImportSearchPathsIsCached = 0x0004,
        IsMarshalingRequiredCached = 0x0010,
        CachedMarshalingRequired = 0x0020,
        NativeAnsi = 0x0040,
        LastError = 0x0080,
        NativeNoMangle = 0x0100,
        VarArgs = 0x0200,
        StdCall = 0x0400,
        ThisCall = 0x0800,
        IsQCall = 0x1000,
        DefaultDllImportSearchPathsStatus = 0x2000,
        NDirectPopulated = 0x8000,
    }

    const(char)* entrypointName;
    union
    {
        const(char)* libName;
        uint ecallId;
    }
    NDirectWriteableData* writeableData;
    void* importThunkGlue;
    uint defaultDllSearchAttr;
    BindingFlags bindingFlags;

    static if (TARGET_x64)
    {
        short numStackArgSize;
    }

}

public struct ComPlusCallInfo
{
public:
final:
    union
    {
        uint* ilStub;
        MethodDesc* methodDesc;
    }
    MethodTable* interfaceMethodTable;
    bool requiresArgWrapping;
    ushort cachedComSlot;

    version (X86)
    {
        ushort numStackArgSize;
        void* retThunk;
    }

}