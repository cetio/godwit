module inc.corhdr;

alias CritSecCookie = void*;

alias RID = uint;
alias MDToken = uint;
alias HalfMDToken = ushort;
alias PCCOR_SIGNATURE = ubyte*;

alias ModuleDef = uint;
alias TypeRef = uint;
alias TypeDef = uint;
alias FieldDef = uint;
alias MethodDef = uint;
alias ParamDef = uint;
alias InterfaceImpl = uint;
alias CustomAttribute = uint;
alias Permission = uint;
alias SignatureDef = uint;
alias Event = uint;
alias Property = uint;
alias MethodImpl = uint;
alias ModuleRef = uint;
alias TypeSpec = uint;
alias AssemblyDef = uint;
alias AssemblyRef = uint;
alias File = uint;
alias ExportedType = uint;
alias ManifestResource = uint;
alias NestedClass = uint;
alias GenericParam = uint;
alias MethodSpec = uint;
alias GenericParamConstraint = uint;

public struct ImageDataDirectory 
{
public:
    uint virtualAddress;
    uint size;

    uint getVirtualAddress()
    {
        return virtualAddress;
    }

    void setVirtualAddress(uint newVirtualAddress)
    {
        virtualAddress = newVirtualAddress;
    }

    uint getSize()
    {
        return size;
    }

    void setSize(uint newSize)
    {
        size = newSize;
    }
}

public struct RuntimeFunction
{
public:
    uint beginAddress;
    uint unwindData;

    uint getBeginAddress()
    {
        return beginAddress;
    }

    void setBeginAddress(uint newBeginAddress)
    {
        beginAddress = newBeginAddress;
    }

    uint getUnwindData()
    {
        return unwindData;
    }

    void setUnwindData(uint newUnwindData)
    {
        unwindData = newUnwindData;
    }
}

enum CorTokenType : uint
{
    ModuleDef = 0x00000000,
    TypeRef = 0x01000000,
    TypeDef = 0x02000000,
    FieldDef = 0x04000000,
    MethodDef = 0x06000000,
    ParamDef = 0x08000000,
    InterfaceImpl = 0x09000000,
    MemberRef = 0x0a000000,
    CustomAttribute = 0x0c000000,
    Permission = 0x0e000000,
    Signature = 0x11000000,
    Event = 0x14000000,
    Property = 0x17000000,
    MethodImpl = 0x19000000,
    ModuleRef = 0x1a000000,
    TypeSpec = 0x1b000000,
    Assembly = 0x20000000,
    AssemblyRef = 0x23000000,
    File = 0x26000000,
    ExportedType = 0x27000000,
    ManifestResource = 0x28000000,
    NestedClass = 0x29000000,
    GenericParam = 0x2a000000,
    MethodSpec = 0x2b000000,
    GenericParamConstraint = 0x2c000000,

    String               = 0x70000000,
    Name                 = 0x71000000,
    // Leave this on the high end value. This does not correspond to metadata table
    BaseType             = 0x72000000
}

enum CorInterfaceType : uint
{
    Dual,
    IUnknown,
    IDispatch,
    IInspectable,
    IInspectableABI,
    IInspectableVFTBL,
    IMarshal
}

enum CorInfoHFAElemType : uint
{
    None,
    Float,
    Double,
    Vector64,
    Vector128,
    Vector256,
    Unknown
}

enum CorElementType : ubyte
{
    End = 0x0,
    Void = 0x1,
    Boolean = 0x2,
    Char = 0x3,
    NInt = 0x18,
    NUInt = 0x19,
    Int8 = 0x4,
    UInt8 = 0x5,
    Int16 = 0x6,
    UInt16 = 0x7,
    Int32 = 0x8,
    UInt32 = 0x9,
    Int64 = 0xa,
    UInt64 = 0xb,
    Float32 = 0xc,
    Float64 = 0xd,
    String = 0xe,
    Ptr = 0xf,
    ByRef = 0x10,
    ValueType = 0x11,
    Class = 0x12,
    Var = 0x13,
    Array = 0x14,
    GenericInstance = 0x15,
    TypedRef = 0x16,
    FnPtr = 0x1b,
    Obj = 0x1c,
    SzArray = 0x1d,
    MVar = 0x1e,
    CmodReqD = 0x1f,
    CmodOpt = 0x20,
    Internal = 0x21,
    Max = 0x22,
    Modifier = 0x40,
    Sentinel = 0x01 | Modifier,
    Pinned = 0x05 | Modifier,
}

// corbpriv.h
//
// Flags used to control the debuggable state of modules and
// assemblies.
//
public enum DebuggerAssemblyControlFlags
{
    None = 0x00,
    UserOverride = 0x01,
    AllowJITOpts = 0x02,
    // obsolete in V2.0, we're always tracking.
    ObsoleteTrackJITInfo = 0x04, 
    ENCEnabled = 0x08,
    IgnorePDBs = 0x20,
    ControlFlagsMask = 0x2F,

    PDBsCopied = 0x10,
    MiscFlagsMask = 0x10,
};