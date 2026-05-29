module godwit.hresult;

public enum HResult
{
    S_OK = 0x00000000,
    S_FALSE = 0x00000001,
    E_ABORT = 0x80004004,
    E_FAIL = 0x80004005,
    E_NOINTERFACE = 0x80004002,
    E_NOTIMPL = 0x80004001,
    E_POINTER = 0x80004003,
    E_UNEXPECTED = 0x8000FFFF,

    E_ACCESSDENIED = 0x80070005,
    E_HANDLE = 0x80070006,
    E_INVALIDARG = 0x80070057,
    E_OUTOFMEMORY = 0x8007000E,
    E_BADIMAGEFORMAT = 0x8007000B,
    E_BOUNDS = 0x8000000B,
    E_PENDING = 0x8000000A,
    E_NOT_SET = 0x80070490,

    CO_E_NOTINITIALIZED = 0x800401F0,
    CO_E_ALREADYINITIALIZED = 0x800401F1,
    CO_E_NOTSUPPORTED = 0x80004021,
    CO_E_CLASSSTRING = 0x800401F3,
    CO_E_APPNOTFOUND = 0x800401F5,
    CO_E_OBJECTNOTCONNECTED = 0x800401FD,

    DISP_E_BADINDEX = 0x8002000B,
    DISP_E_OVERFLOW = 0x8002000A,
    DISP_E_TYPEMISMATCH = 0x80020005,
    DISP_E_PARAMNOTFOUND = 0x80020004,
    DISP_E_UNKNOWNINTERFACE = 0x80020001,

    RPC_E_CHANGED_MODE = 0x80010106,
    RPC_E_TOO_LATE = 0x80010119,
    RPC_E_INVALIDMETHOD = 0x80010104,
    RPC_E_DISCONNECTED = 0x80010108,
    RPC_E_SERVERFAULT = 0x80010105,
    RPC_E_TIMEOUT = 0x8001011F,
    RPC_E_NOT_REGISTERED = 0x80010103,
    RPC_E_DUPLICATE_NAME = 0x8001012C,
}

public:
static:
pure:
@nogc:
/// Checks HResult
bool OK(HResult hr)
    => hr == HResult.S_OK;

/// ditto
bool NOTOK(HResult hr)
    => hr != HResult.S_OK;

/// ditto
bool FALSE(HResult hr)
    => hr == HResult.S_FALSE;

/// ditto
bool ABORT(HResult hr)
    => hr == HResult.E_ABORT;

/// ditto
bool FAIL(HResult hr)
    => hr == HResult.E_FAIL;

/// ditto
bool NOINTERFACE(HResult hr)
    => hr == HResult.E_NOINTERFACE;

/// ditto
bool NOTIMPL(HResult hr)
    => hr == HResult.E_NOTIMPL;

/// ditto
bool POINTER(HResult hr)
    => hr == HResult.E_POINTER;

/// ditto
bool UNEXPECTED(HResult hr)
    => hr == HResult.E_UNEXPECTED;

/// ditto
bool ACCESSDENIED(HResult hr)
    => hr == HResult.E_ACCESSDENIED;

/// ditto
bool HANDLE(HResult hr)
    => hr == HResult.E_HANDLE;

/// ditto
bool INVALIDARG(HResult hr)
    => hr == HResult.E_INVALIDARG;

/// ditto
bool OUTOFMEMORY(HResult hr)
    => hr == HResult.E_OUTOFMEMORY;

/// ditto
bool BADIMAGEFORMAT(HResult hr)
    => hr == HResult.E_BADIMAGEFORMAT;

/// ditto
bool BOUNDS(HResult hr)
    => hr == HResult.E_BOUNDS;

/// ditto
bool PENDING(HResult hr)
    => hr == HResult.E_PENDING;

/// ditto
bool NOT_SET(HResult hr)
    => hr == HResult.E_NOT_SET;

/// ditto
bool NOTINITIALIZED(HResult hr)
    => hr == HResult.CO_E_NOTINITIALIZED;

/// ditto
bool ALREADYINITIALIZED(HResult hr)
    => hr == HResult.CO_E_ALREADYINITIALIZED;

/// ditto   
bool NOTSUPPORTED(HResult hr)
    => hr == HResult.CO_E_NOTSUPPORTED;


/// ditto
bool CLASSSTRING(HResult hr)
    => hr == HResult.CO_E_CLASSSTRING;

/// ditto
bool APPNOTFOUND(HResult hr)
    => hr == HResult.CO_E_APPNOTFOUND;

/// ditto
bool OBJECTNOTCONNECTED(HResult hr)
    => hr == HResult.CO_E_OBJECTNOTCONNECTED;

/// ditto
bool BADINDEX(HResult hr)
    => hr == HResult.DISP_E_BADINDEX;

/// ditto
bool OVERFLOW(HResult hr)
    => hr == HResult.DISP_E_OVERFLOW;

/// ditto
bool TYPEMISMATCH(HResult hr)
    => hr == HResult.DISP_E_TYPEMISMATCH;

/// ditto
bool PARAMNOTFOUND(HResult hr)
    => hr == HResult.DISP_E_PARAMNOTFOUND;

/// ditto
bool UNKNOWNINTERFACE(HResult hr)
    => hr == HResult.DISP_E_UNKNOWNINTERFACE;

/// ditto
bool CHANGEDMODE(HResult hr)
    => hr == HResult.RPC_E_CHANGED_MODE;

/// ditto
bool TOOLATE(HResult hr)
    => hr == HResult.RPC_E_TOO_LATE;

/// ditto
bool INVALIDMETHOD(HResult hr)
    => hr == HResult.RPC_E_INVALIDMETHOD;

/// ditto
bool DISCONNECTED(HResult hr)
    => hr == HResult.RPC_E_DISCONNECTED;

/// ditto
bool SERVERFAULT(HResult hr)
    => hr == HResult.RPC_E_SERVERFAULT;

/// ditto
bool TIMEOUT(HResult hr)
    => hr == HResult.RPC_E_TIMEOUT;

/// ditto
bool NOTREGISTERED(HResult hr)
    => hr == HResult.RPC_E_NOT_REGISTERED;

/// ditto
bool DUPLICATENAME(HResult hr)
    => hr == HResult.RPC_E_DUPLICATE_NAME;