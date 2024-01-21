module godwit.backend.vm.method;

import std.bitmanip;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.methodimpl;
import godwit.backend.metadata;
import godwit.backend.vm.genericdict;
import caiman.traits;
import godwit.impl;
import caiman.state;

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
    /// The size of this chunk minus 1
    ubyte m_size;
    /// The number of `MethodDesc` in this chunk minus 1
    ubyte m_count;
    ChunkFlags m_chunkFlags;

    ushort tokenRange()
    {
        return cast(ushort)(chunkFlags & ChunkFlags.TokenRangeMask);
    }

    MethodDesc*[] methods()
        scope return
    {
        MethodDesc*[] ret;
        uint size;
        foreach (i; 0..(count + 1))
        {
            ubyte* pMD = cast(ubyte*)&this + size + MethodDescChunk.sizeof;
            pMD += cast(ptrdiff_t)pMD % ptrdiff_t.sizeof;

            // WE LOVE CASTS!!!!
            ret ~= cast(MethodDesc*)pMD;
            MethodDesc._chunkLookup[*cast(MethodDesc*)pMD] = &this;

            size += (cast(MethodDesc*)pMD).sizeOf;
        }
        return ret;
    }

    mixin accessors;
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

    static if (DEBUG)
    {
        const(char)* m_debugMethodName;
        const(char)* m_debugClassName;
        const(char)* m_debugMethodSignature;
        MethodTable* m_debugMethodTable;
        // ----> GCCoverageInfo <----
        uint* m_gcCover;
    }
    CodeFlags m_codeFlags;
    ubyte m_chunkIndex;
    ubyte m_methodIndex;
    ushort m_slotNumber;
    mixin(bitfields!(
        Classification, "m_classification", 3,
        MethodProperties, "m_properties", 13
    ));

    /// TODO: This is bad, fix later
    package static MethodDescChunk*[MethodDesc] _chunkLookup;

    /// This is incredibly unstable and needs worked on,
    /// built upon sticks and stones because this constantly exhibits UB.
    uint sizeOf()
    {
        uint baseSize;
        switch (classification)
        {
            case Classification.IL:
                baseSize = MethodDesc.sizeof - 8;
                break;
            case Classification.FCall:
                baseSize = FCallMethodDesc.sizeof;
                break;
            case Classification.NDirect:
                baseSize = NDirectMethodDesc.sizeof;
                break;
            case Classification.EEImpl:
                baseSize = EEImplMethodDesc.sizeof;
                break;
            case Classification.Array:
                baseSize = ArrayMethodDesc.sizeof;
                break;
            case Classification.Instantiated:
                baseSize = InstantiatedMethodDesc.sizeof - 20;
                break;
            case Classification.Dynamic:
                baseSize = DynamicMethodDesc.sizeof;
                break;
            default:
                break;
        }

        static if (COM_INTEROP)
            baseSize += ComPlusCallInfo.sizeof;

        if (isHasNonVtableSlot)
            baseSize += size_t.sizeof;

        if (isMethodImpl)
            baseSize += MethodImpl.sizeof;

        if (isHasNativeCodeSlot)
            baseSize += size_t.sizeof;

        return baseSize;
    }

    MethodDescChunk* methodDescChunk()
        scope return
    {
        return _chunkLookup[this];
    }

    MethodDef token()
    {
        ushort range = methodDescChunk.tokenRange;
        ushort rem = codeFlags & CodeFlags.TokenRemainderMask;

        // METHOD_TOKEN_REMAINDER_BIT_COUNT
        return (range << 12) | rem | CorTokenType.MethodDef;
    }

    mixin accessors;
}

public struct InstantiatedMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
    @flags enum InstantiationFlags : ushort
    {
        KindMask = 0x07,
        GenericMethodDefinition = 0x01,
        UnsharedMethodInstantiation = 0x02,
        SharedMethodInstantiation = 0x03,
        WrapperStubWithInstantiations = 0x04,
    }

    union
    {
        // ----> DictionaryLayout <----
        ubyte* m_dictLayout;
        MethodDesc* m_wrappedMethodDesc;
    }
    Dictionary* m_perInstInfo;
    InstantiationFlags m_instFlags;
    ushort m_genericsCount;

    mixin accessors;
}

public struct ComPlusCallMethodDesc
{
    MethodDesc methodDesc;
    alias methodDesc this;

public:
final:
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

    const(char)* m_methodName;
    // ----> DynamicResolver <----
    ubyte* m_resolver;

    mixin accessors;
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

    const(char)* m_entrypointName;
    union
    {
        const(char)* m_libName;
        /// ECallID for QCalls
        uint m_ecallId;
    }
    /// The JIT generates an indirect call through this location in some cases.
    /// Initialized to NDirectImportThunkGlue. Patched to the true target or
    /// host interceptor stub or alignment thunk after linking.
    NDirectWriteableData* m_writeableData;
    // Defining a struct for this is useless, as it has an ifdef but always has a size of 8
    // and is just a padding field (for whatever reason?)
    // NDirectImportThunkGlue
    void* m_importThunkGlue;
    uint m_defaultDllSearchAttr;
    BindingFlags m_bindingFlags;
    static if (TARGET_x64)
    {
        /// Size of outgoing arguments (on stack). Note that in order to get the @n stdcall name decoration,
        short m_numStackArgSize;
    }

    mixin accessors;
}

public struct ComPlusCallInfo
{
public:
final:
    union
    {
        // IL stub for CLR to COM call
        uint* m_ilStub;
        // MethodDesc of the COM event provider to forward the call to (COM event interfaces)
        MethodDesc* m_methodDesc;
    }
    MethodTable* m_interfaceMethodTable;
    bool m_requiresArgWrapping;
    ushort m_cachedComSlot;
    version (X86)
    {
        // Size of outgoing arguments (on stack). This is currently used only
        // on x86 when we have an InlinedCallFrame representing a CLR->COM call.
        ushort m_numStackArgSize;
        void* m_retThunk;
    }

    mixin accessors;
}