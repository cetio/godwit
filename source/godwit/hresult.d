module godwit.hresult;

public enum HResult
{
    SOk = 0x00000000,
    SFalse = 0x00000001,
    EAbort = 0x80004004,
    EFail = 0x80004005,
    ENoInterface = 0x80004002,
    ENotImpl = 0x80004001,
    EPointer = 0x80004003,
    EUnexpected = 0x8000FFFF,

    EAccessDenied = 0x80070005,
    EHandle = 0x80070006,
    EInvalidArg = 0x80070057,
    EOutOfMemory = 0x8007000E,
    EBadImageFormat = 0x8007000B,
    EBounds = 0x8000000B,
    EPending = 0x8000000A,
    ENotSet = 0x80070490,

    CoENotInitialized = 0x800401F0,
    CoEAlreadyInitialized = 0x800401F1,
    CoENotSupported = 0x80004021,
    CoEClassString = 0x800401F3,
    CoEAppNotFound = 0x800401F5,
    CoEObjectNotConnected = 0x800401FD,

    DispEBadIndex = 0x8002000B,
    DispEOverflow = 0x8002000A,
    DispETypeMismatch = 0x80020005,
    DispEParamNotFound = 0x80020004,
    DispEUnknownInterface = 0x80020001,

    RpcEChangedMode = 0x80010106,
    RpcETooLate = 0x80010119,
    RpcEInvalidMethod = 0x80010104,
    RpcEDisconnected = 0x80010108,
    RpcEServerFault = 0x80010105,
    RpcETimeout = 0x8001011F,
    RpcENotRegistered = 0x80010103,
    RpcEDuplicateName = 0x8001012C,
}

public:
static:
pure:
@nogc:
/// Checks HResult
bool IsOk(HResult hr)
    => hr == HResult.SOk;

/// ditto
bool IsNotOk(HResult hr)
    => hr != HResult.SOk;

/// ditto
bool IsFalse(HResult hr)
    => hr == HResult.SFalse;

/// ditto
bool IsAbort(HResult hr)
    => hr == HResult.EAbort;

/// ditto
bool IsFail(HResult hr)
    => hr == HResult.EFail;

/// ditto
bool IsNoInterface(HResult hr)
    => hr == HResult.ENoInterface;

/// ditto
bool IsNotImpl(HResult hr)
    => hr == HResult.ENotImpl;

/// ditto
bool IsPointer(HResult hr)
    => hr == HResult.EPointer;

/// ditto
bool IsUnexpected(HResult hr)
    => hr == HResult.EUnexpected;

/// ditto
bool IsAccessDenied(HResult hr)
    => hr == HResult.EAccessDenied;

/// ditto
bool IsHandle(HResult hr)
    => hr == HResult.EHandle;

/// ditto
bool IsInvalidArg(HResult hr)
    => hr == HResult.EInvalidArg;

/// ditto
bool IsOutOfMemory(HResult hr)
    => hr == HResult.EOutOfMemory;

/// ditto
bool IsBadImageFormat(HResult hr)
    => hr == HResult.EBadImageFormat;

/// ditto
bool IsBounds(HResult hr)
    => hr == HResult.EBounds;

/// ditto
bool IsPending(HResult hr)
    => hr == HResult.EPending;

/// ditto
bool IsNotSet(HResult hr)
    => hr == HResult.ENotSet;

/// ditto
bool IsNotInitialized(HResult hr)
    => hr == HResult.CoENotInitialized;

/// ditto
bool IsAlreadyInitialized(HResult hr)
    => hr == HResult.CoEAlreadyInitialized;

/// ditto
bool IsNotSupported(HResult hr)
    => hr == HResult.CoENotSupported;


/// ditto
bool IsClassString(HResult hr)
    => hr == HResult.CoEClassString;

/// ditto
bool IsAppNotFound(HResult hr)
    => hr == HResult.CoEAppNotFound;

/// ditto
bool IsObjectNotConnected(HResult hr)
    => hr == HResult.CoEObjectNotConnected;

/// ditto
bool IsBadIndex(HResult hr)
    => hr == HResult.DispEBadIndex;

/// ditto
bool IsOverflow(HResult hr)
    => hr == HResult.DispEOverflow;

/// ditto
bool IsTypeMismatch(HResult hr)
    => hr == HResult.DispETypeMismatch;

/// ditto
bool IsParamNotFound(HResult hr)
    => hr == HResult.DispEParamNotFound;

/// ditto
bool IsUnknownInterface(HResult hr)
    => hr == HResult.DispEUnknownInterface;

/// ditto
bool IsChangedMode(HResult hr)
    => hr == HResult.RpcEChangedMode;

/// ditto
bool IsTooLate(HResult hr)
    => hr == HResult.RpcETooLate;

/// ditto
bool IsInvalidMethod(HResult hr)
    => hr == HResult.RpcEInvalidMethod;

/// ditto
bool IsDisconnected(HResult hr)
    => hr == HResult.RpcEDisconnected;

/// ditto
bool IsServerFault(HResult hr)
    => hr == HResult.RpcEServerFault;

/// ditto
bool IsTimeout(HResult hr)
    => hr == HResult.RpcETimeout;

/// ditto
bool IsNotRegistered(HResult hr)
    => hr == HResult.RpcENotRegistered;

/// ditto
bool IsDuplicateName(HResult hr)
    => hr == HResult.RpcEDuplicateName;