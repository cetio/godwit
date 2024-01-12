/// Provides interface for enums, properties, and hresult
module godwit.mem.state;

import std.traits;
import godwit.llv.traits;

public:
static:
/**
* Checks if a value has a specific flag set.
*
* Params:
*   - `value`: The value to check for the flag.
*   - `flag`: The flag to check within the value.
*
* Returns:
*     A boolean indicating whether the flag is set in the value.
*/
@nogc bool hasFlag(T)(T value, T flag)
{
    return (value & flag) != 0;
}

/**
* Checks if a value's masked portion matches a specific flag.
*
* Params:
*   - `value`: The value to check for the flag match.
*   - `mask`: The mask to apply to the value.
*   - `flag`: The flag to match within the masked value.
*
* Returns:
*     A boolean indicating whether the flag matches the masked value.
*/
@nogc bool hasFlagMasked(T)(T value, T mask, T flag)
{
    return (value & mask) == flag;
}

/**
* Sets or clears a flag in a value based on the provided state.
*
* Params:
*   - `value`: Reference to the value where the flag will be modified.
*   - `flag`: The flag to set or clear.
*   - `state`: A boolean indicating whether to set or clear the flag.
*/
@nogc void setFlag(T)(ref T value, T flag, bool state)
{
    value = cast(T)(state ? (value | flag) : (value & ~flag));
}

/**
* Toggles a flag in a value.
*
* Params:
*   - `value`: Reference to the value where the flag will be toggled.
*   - `flag`: The flag to toggle.
*/
@nogc void toggleFlag(T)(ref T value, T flag)
{
    value = cast(T)(value ^ flag);
}

/**
* Sets a flag in a masked value based on the provided state.
*
* Params:
*   - `value`: Reference to the value where the flag will be modified.
*   - `mask`: The mask to apply to the value.
*   - `flag`: The flag to set or clear.
*   - `state`: A boolean indicating whether to set or clear the flag.
*/
@nogc void setFlagMasked(T)(ref T value, T mask, T flag, bool state)
{
    value = cast(T)(state ? (value & mask) | flag : (value & mask) & ~flag);
}

/**
* Toggles a flag within a masked value.
*
* Params:
*   - `value`: Reference to the value where the flag will be toggled.
*   - `mask`: The mask to apply to the value.
*   - `flag`: The flag to toggle within the masked value.
*/
@nogc void toggleFlagMasked(T)(ref T value, T mask, T flag)
{
    value = cast(T)((value & mask) ^ flag);
}

/**
* Clears a mask from the provided value.
*
* Params:
*   - `value`: The value from which the mask will be cleared.
*   - `mask`: The mask to clear from the value.
*
* Returns:
*     The value after clearing the specified mask.
*/
@nogc T clearMask(T)(T value, T mask)
{
    return cast(T)(value & ~mask);
}

/**
* Generates a string representation of a value based on its flag members.
*
* Params:
*   - `value`: The value for which to generate the string representation.
*
* Returns:
*     A string representing the flag members set in the value.
*/
pure string toString(T)(T value) const
{
    foreach (string member; __traits(allMembers, T))
    {
        if (value.hasFlag(__traits(getMember, T, member)))
        {
            string str;
            foreach (m; __traits(allMembers, T))
            {
                if (value.hasFlag(__traits(getMember, T, m)))
                    str ~= m ~ " | ";
            }
            return str[0 .. $ - 3];
        }
    }
    return __traits(allMembers, T)[0];
}

/// Enumeration of HResult values for handling error codes.
public @exempt enum HResult
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

/// Checks HResult
pure bool OK(HResult hr)
{
    return hr == HResult.S_OK;
}

/// ditto
pure bool NOTOK(HResult hr)
{
    return hr != HResult.S_OK;
}

/// ditto
pure bool FALSE(HResult hr)
{
    return hr == HResult.S_FALSE;
}

/// ditto
pure bool ABORT(HResult hr)
{
    return hr == HResult.E_ABORT;
}

/// ditto
pure bool FAIL(HResult hr)
{
    return hr == HResult.E_FAIL;
}

/// ditto
pure bool NOINTERFACE(HResult hr)
{
    return hr == HResult.E_NOINTERFACE;
}

/// ditto
pure bool NOTIMPL(HResult hr)
{
    return hr == HResult.E_NOTIMPL;
}

/// ditto
pure bool POINTER(HResult hr)
{
    return hr == HResult.E_POINTER;
}

/// ditto
pure bool UNEXPECTED(HResult hr)
{
    return hr == HResult.E_UNEXPECTED;
}

/// ditto
pure bool ACCESSDENIED(HResult hr)
{
    return hr == HResult.E_ACCESSDENIED;
}

/// ditto
pure bool HANDLE(HResult hr)
{
    return hr == HResult.E_HANDLE;
}

/// ditto
pure bool INVALIDARG(HResult hr)
{
    return hr == HResult.E_INVALIDARG;
}

/// ditto
pure bool OUTOFMEMORY(HResult hr)
{
    return hr == HResult.E_OUTOFMEMORY;
}

/// ditto
pure bool BADIMAGEFORMAT(HResult hr)
{
    return hr == HResult.E_BADIMAGEFORMAT;
}

/// ditto
pure bool BOUNDS(HResult hr)
{
    return hr == HResult.E_BOUNDS;
}

/// ditto
pure bool PENDING(HResult hr)
{
    return hr == HResult.E_PENDING;
}

/// ditto
pure bool NOT_SET(HResult hr)
{
    return hr == HResult.E_NOT_SET;
}

/// ditto
pure bool NOTINITIALIZED(HResult hr)
{
    return hr == HResult.CO_E_NOTINITIALIZED;
}

/// ditto
pure bool ALREADYINITIALIZED(HResult hr)
{
    return hr == HResult.CO_E_ALREADYINITIALIZED;
}

/// ditto
pure bool NOTSUPPORTED(HResult hr)
{
    return hr == HResult.CO_E_NOTSUPPORTED;
}

/// ditto
pure bool CLASSSTRING(HResult hr)
{
    return hr == HResult.CO_E_CLASSSTRING;
}

/// ditto
pure bool APPNOTFOUND(HResult hr)
{
    return hr == HResult.CO_E_APPNOTFOUND;
}

/// ditto
pure bool OBJECTNOTCONNECTED(HResult hr)
{
    return hr == HResult.CO_E_OBJECTNOTCONNECTED;
}

/// ditto
pure bool BADINDEX(HResult hr)
{
    return hr == HResult.DISP_E_BADINDEX;
}

/// ditto
pure bool OVERFLOW(HResult hr)
{
    return hr == HResult.DISP_E_OVERFLOW;
}

/// ditto
pure bool TYPEMISMATCH(HResult hr)
{
    return hr == HResult.DISP_E_TYPEMISMATCH;
}

/// ditto
pure bool PARAMNOTFOUND(HResult hr)
{
    return hr == HResult.DISP_E_PARAMNOTFOUND;
}

/// ditto
pure bool UNKNOWNINTERFACE(HResult hr)
{
    return hr == HResult.DISP_E_UNKNOWNINTERFACE;
}

/// ditto
pure bool CHANGEDMODE(HResult hr)
{
    return hr == HResult.RPC_E_CHANGED_MODE;
}

/// ditto
pure bool TOOLATE(HResult hr)
{
    return hr == HResult.RPC_E_TOO_LATE;
}

/// ditto
pure bool INVALIDMETHOD(HResult hr)
{
    return hr == HResult.RPC_E_INVALIDMETHOD;
}

/// ditto
pure bool DISCONNECTED(HResult hr)
{
    return hr == HResult.RPC_E_DISCONNECTED;
}

/// ditto
pure bool SERVERFAULT(HResult hr)
{
    return hr == HResult.RPC_E_SERVERFAULT;
}

/// ditto
pure bool TIMEOUT(HResult hr)
{
    return hr == HResult.RPC_E_TIMEOUT;
}

/// ditto
pure bool NOTREGISTERED(HResult hr)
{
    return hr == HResult.RPC_E_NOT_REGISTERED;
}

/// ditto
pure bool DUPLICATENAME(HResult hr)
{
    return hr == HResult.RPC_E_DUPLICATE_NAME;
}