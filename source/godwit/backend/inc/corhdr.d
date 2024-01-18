/// Provides interface to low level runtime type/token data.
module godwit.backend.inc.corhdr;

import caiman.traits;

/// ??? Runtime data.
alias CritSecCookie = void*;

/// Row ID, assigned to `uint`
alias RID = uint;
/// Base token, assigned to `uint`
alias MDToken = uint;
/// Half of an `MDToken`, contains the same data, used for types.
alias HalfMDToken = ushort;
/// Signature containing compressed data, usually.
alias PCCOR_SIGNATURE = ubyte*;

/// See `CorTokenType`
/// 
/// Base token, assigned to `uint`
alias ModuleDef = uint;
alias TypeRef = uint; /// ditto
alias TypeDef = uint; /// ditto
alias FieldDef = uint; /// ditto
alias MethodDef = uint; /// ditto
alias ParamDef = uint; /// ditto
alias InterfaceImpl = uint; /// ditto
alias CustomAttribute = uint; /// ditto
alias Permission = uint; /// ditto
alias SignatureDef = uint; /// ditto
alias Event = uint; /// ditto
alias Property = uint; /// ditto
alias MethodImpl = uint; /// ditto
alias ModuleRef = uint; /// ditto
alias TypeSpec = uint; /// ditto
alias AssemblyDef = uint; /// ditto
alias AssemblyRef = uint; /// ditto
alias File = uint; /// ditto
alias ExportedType = uint; /// ditto
alias ManifestResource = uint; /// ditto
alias NestedClass = uint; /// ditto
alias GenericParam = uint; /// ditto
alias MethodSpec = uint; /// ditto
alias GenericParamConstraint = uint; /// ditto

/// ???
/// Possibly for identifying CoreCLR PE data directory?
public struct ImageDataDirectory 
{
public:
final:
    uint m_virtualAddress;
    uint m_size;

    mixin accessors;
}

/// ???
public struct RuntimeFunction
{
public:
final:
    uint m_beginAddress;
    uint m_unwindData;

    mixin accessors;
}

/// Base tokens, used by the runtime for identifying stored structures
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

/// Base interface types, I'm not sure what these mean.
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

/// SIMD/Vector object/type info used for all floating points.
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

/// Base types for all objects and types.
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
/// Flags used to control the debuggable state of modules and
/// assemblies.
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
}