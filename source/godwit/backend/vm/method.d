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
        TokenRangeMask = 0x0FFF,
        DeterminedIsEligibleForTieredCompilation = 0x4000,
        LoaderModuleAttachedToChunk = 0x8000,
    }

    MethodTable* m_methodTable;
    MethodDescChunk* m_next;
    /// The size of this chunk minus 1 (in multiples of MethodDesc.ALIGNMENT)
    ubyte m_size;
    /// The number of MethodDescs in this chunk minus 1
    ubyte m_count;
    ChunkFlags m_flagsAndTokenRange;

    ushort tokenRange()
    {
        return cast(ushort)(m_flagsAndTokenRange & ChunkFlags.TokenRangeMask);
    }

    MethodDesc*[] methods()
        scope return
    {
        MethodDesc*[] ret;
        MethodDesc* pMD = cast(MethodDesc*)(cast(ubyte*)&this + MethodDescChunk.sizeof);
        foreach (i; 0..(m_count + 1))
        {
            ret ~= pMD;
            pMD = cast(MethodDesc*)(cast(ubyte*)pMD + pMD.sizeOf);
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
        HasAsyncMethodData = 0x0040,
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

    enum Flags3 : ushort
    {
        TokenRemainderMask = 0x0FFF,
        HasStableEntryPoint = 0x1000,
        HasPrecode = 0x2000,
        IsUnboxingStub = 0x4000,
        IsEligibleForTieredCompilation = 0x8000
    }

    enum Flags4 : ubyte
    {
        ComputedRequiresStableEntryPoint = 0x01,
        RequiresStableEntryPoint = 0x02,
        TemporaryEntryPointAssigned = 0x04,
        EnCAddedMethod = 0x08,
        PendingThunkResolution = 0x10,
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

    ushort m_flags3AndTokenRemainder;
    ubyte m_chunkIndex;
    ubyte m_flags4;
    ushort m_slotNumber;
    ushort m_flags;
    MethodDescCodeData* m_codeData;

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
        return cast(Classification)(m_flags & 0x0007);
    }

    uint sizeOf()
    {
        uint baseSize;
        switch (classification)
        {
            case Classification.IL:
                baseSize = cast(uint)MethodDesc.sizeof;
                break;
            case Classification.FCall:
                baseSize = cast(uint)FCallMethodDesc.sizeof;
                break;
            case Classification.NDirect:
                baseSize = cast(uint)NDirectMethodDesc.sizeof;
                break;
            case Classification.EEImpl:
                baseSize = cast(uint)EEImplMethodDesc.sizeof;
                break;
            case Classification.Array:
                baseSize = cast(uint)ArrayMethodDesc.sizeof;
                break;
            case Classification.Instantiated:
                baseSize = cast(uint)InstantiatedMethodDesc.sizeof;
                break;
            case Classification.Dynamic:
                baseSize = cast(uint)DynamicMethodDesc.sizeof;
                break;
            default:
                break;
        }

        static if (COM_INTEROP)
            baseSize += cast(uint)ComPlusCallInfo.sizeof;

        if ((m_flags & Properties.HasNonVtableSlot) != 0)
            baseSize += size_t.sizeof;

        if ((m_flags & Properties.MethodImpl) != 0)
            baseSize += cast(uint)MethodImpl.sizeof;

        if ((m_flags & Properties.HasNativeCodeSlot) != 0)
            baseSize += size_t.sizeof;

        if ((m_flags & Properties.HasAsyncMethodData) != 0)
            baseSize += cast(uint)AsyncMethodData.sizeof;

        return baseSize;
    }

    int methodDescChunkIndex()
    {
        return m_chunkIndex;
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
        ushort rem = m_flags3AndTokenRemainder & Flags3.TokenRemainderMask;
        return (range << 12) | rem | CorTokenType.MethodDef;
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
        void* m_dictLayout;
        MethodDesc* m_wrappedMethodDesc;
    }
    Dictionary* m_perInstInfo;
    ushort m_flags2;
    ushort m_numGenericArgs;

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
    size_t m_sig;
    uint m_count;
    uint m_extendedFlags;

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
    uint m_ecallId;

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

    const(char)* m_methodName;
    void* m_resolver;

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
    void* m_directTarget;

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

    const(char)* m_entrypointName;
    union
    {
        const(char)* m_libName;
        uint m_ecallId;
    }
    NDirectWriteableData* m_writeableData;
    void* m_importThunkGlue;
    uint m_defaultDllSearchAttr;
    BindingFlags m_bindingFlags;

    static if (TARGET_x64)
    {
        short m_numStackArgSize;
    }

}

public struct ComPlusCallInfo
{
public:
final:
    union
    {
        uint* m_ilStub;
        MethodDesc* m_methodDesc;
    }
    MethodTable* m_interfaceMethodTable;
    bool m_requiresArgWrapping;
    ushort m_cachedComSlot;

    version (X86)
    {
        ushort m_numStackArgSize;
        void* m_retThunk;
    }

}