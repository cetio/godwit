module hresult;

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
bool OK(HResult hr)
{
    return hr == HResult.S_OK;
}

bool NOTOK(HResult hr)
{
    return hr != HResult.S_OK;
}

bool FALSE(HResult hr)
{
    return hr == HResult.S_FALSE;
}

bool ABORT(HResult hr)
{
    return hr == HResult.E_ABORT;
}

bool FAIL(HResult hr)
{
    return hr == HResult.E_FAIL;
}

bool NOINTERFACE(HResult hr)
{
    return hr == HResult.E_NOINTERFACE;
}

bool NOTIMPL(HResult hr)
{
    return hr == HResult.E_NOTIMPL;
}

bool POINTER(HResult hr)
{
    return hr == HResult.E_POINTER;
}

bool UNEXPECTED(HResult hr)
{
    return hr == HResult.E_UNEXPECTED;
}

bool ACCESSDENIED(HResult hr)
{
    return hr == HResult.E_ACCESSDENIED;
}

bool HANDLE(HResult hr)
{
    return hr == HResult.E_HANDLE;
}

bool INVALIDARG(HResult hr)
{
    return hr == HResult.E_INVALIDARG;
}

bool OUTOFMEMORY(HResult hr)
{
    return hr == HResult.E_OUTOFMEMORY;
}

bool BADIMAGEFORMAT(HResult hr)
{
    return hr == HResult.E_BADIMAGEFORMAT;
}

bool BOUNDS(HResult hr)
{
    return hr == HResult.E_BOUNDS;
}

bool PENDING(HResult hr)
{
    return hr == HResult.E_PENDING;
}

bool NOT_SET(HResult hr)
{
    return hr == HResult.E_NOT_SET;
}

bool NOTINITIALIZED(HResult hr)
{
    return hr == HResult.CO_E_NOTINITIALIZED;
}

bool ALREADYINITIALIZED(HResult hr)
{
    return hr == HResult.CO_E_ALREADYINITIALIZED;
}

bool NOTSUPPORTED(HResult hr)
{
    return hr == HResult.CO_E_NOTSUPPORTED;
}

bool CLASSSTRING(HResult hr)
{
    return hr == HResult.CO_E_CLASSSTRING;
}

bool APPNOTFOUND(HResult hr)
{
    return hr == HResult.CO_E_APPNOTFOUND;
}

bool OBJECTNOTCONNECTED(HResult hr)
{
    return hr == HResult.CO_E_OBJECTNOTCONNECTED;
}

bool BADINDEX(HResult hr)
{
    return hr == HResult.DISP_E_BADINDEX;
}

bool OVERFLOW(HResult hr)
{
    return hr == HResult.DISP_E_OVERFLOW;
}

bool TYPEMISMATCH(HResult hr)
{
    return hr == HResult.DISP_E_TYPEMISMATCH;
}

bool PARAMNOTFOUND(HResult hr)
{
    return hr == HResult.DISP_E_PARAMNOTFOUND;
}

bool UNKNOWNINTERFACE(HResult hr)
{
    return hr == HResult.DISP_E_UNKNOWNINTERFACE;
}

bool CHANGEDMODE(HResult hr)
{
    return hr == HResult.RPC_E_CHANGED_MODE;
}

bool TOOLATE(HResult hr)
{
    return hr == HResult.RPC_E_TOO_LATE;
}

bool INVALIDMETHOD(HResult hr)
{
    return hr == HResult.RPC_E_INVALIDMETHOD;
}

bool DISCONNECTED(HResult hr)
{
    return hr == HResult.RPC_E_DISCONNECTED;
}

bool SERVERFAULT(HResult hr)
{
    return hr == HResult.RPC_E_SERVERFAULT;
}

bool TIMEOUT(HResult hr)
{
    return hr == HResult.RPC_E_TIMEOUT;
}

bool NOTREGISTERED(HResult hr)
{
    return hr == HResult.RPC_E_NOT_REGISTERED;
}

bool DUPLICATENAME(HResult hr)
{
    return hr == HResult.RPC_E_DUPLICATE_NAME;
}