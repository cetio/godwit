/// Provides functions for working with signatures and their data. \
/// Very confusing, so some documentation may not be very helpful.
module godwit.backend.inc.cor;

import godwit.backend.inc.corhdr;
import godwit.hresult;

/*
This file does not include any compression, only decompression
You can see the omitted functions at https://github.com/dotnet/runtime/blob/main/src/coreclr/inc/cor.h
- uint corSigCompressData(uint, void*)
- uint corSigCompressToken(MDToken, void*)
- uint corSigCompressSignedInt(int, void*)
- uint corSigCompressElementType(out CorElementType, void*)
- uint corSigCompressPointer(void*, void*)
*/

public:
static:
/**
    Converts a RID (Row IDentifier) to a token.

    Params:
    - `rid`: Row IDentifier.
    - `tkType`: Type of the token.

    Returns:
        Token corresponding to the given RID and token type.
*/
pure RID ridToToken(RID rid, CorTokenType tkType)
{
    return rid |= tkType;
}

/**
    Constructs a token from a RID (Row IDentifier) and token type.

    Params:
    - `rid`: Row IDentifier.
    - `tkType`: Type of the token.

    Returns:
        Token constructed from the given RID and token type.
*/
pure MDToken tokenFromRid(RID rid, CorTokenType tkType)
{
    return rid | tkType;
}

/**
    Extracts RID (Row IDentifier) from a token.

    Params:
    - `tk`: Token.

    Returns:
        Extracted RID from the given token.
*/
pure RID ridFromToken(MDToken tk)
{
    return tk & 0x00ffffff;
}

/**
    Retrieves the type portion from a token.

    Params:
    - `tk`: Token.

    Returns:
        Type portion from the given token.
*/
pure uint typeFromToken(MDToken tk)
{
    return tk & 0xff000000;
}

/**
    Checks if a token is nil.

    Params:
    - `tk`: Token.

    Returns:
        True if the token is nil; otherwise, false.
*/
pure bool isNilToken(MDToken tk)
{
    return ridFromToken(tk) == 0;
}

/**
    Checks if a `CorElementType` is a primitive type.

    Params:
    - `elemType`: `CorElementType` to be checked.

    Returns:
        True if `elemType` is a primitive type, otherwise, false.
*/
pure bool corIsPrimitiveType(CorElementType elemType)
{
    return elemType < CorElementType.Ptr || elemType == CorElementType.NInt || elemType == CorElementType.NUInt;
}

/**
    Checks if a `CorElementType` is a modified element type

    Params:
    - `elemType`: `CorElementType` to be checked.

    Returns:
        True if `elementType` is a pointer, byref, or has any modifier set, otherwise, false.
*/
pure bool corIsModifierElementType(CorElementType elemType)
{
    if (elemType == CorElementType.Ptr || elemType == CorElementType.ByRef)
        return true;

    return (elemType & CorElementType.Modifier) != 0;
}

/**
    Decompresses the size of the data of a signature.

    Params:
    - `data`: Signature to have decompressed.

    Returns:
        Data size of `data`.
*/
pure uint corSigUncompressedDataSize(PCCOR_SIGNATURE data)
{
    if ((data[0] & 0x80) == 0)
        return 1;

    if ((data[0] & 0xC0) == 0x80)
        return 2;

    return 4;
}

/**
    Decompresses big data from a signature.

    Params:
    - `data`: Signature to be decompressed.

    Returns:
        Decompressed big data from the signature.
*/
pure uint corSigUncompressBigData(ref PCCOR_SIGNATURE data)
{
    uint res;

    // Medium.
    if ((*data & 0xC0) == 0x80)  // 10?? ????
    {
        res = cast(uint)((*data++ & 0x3f) << 8);
        res |= *data++;
    }
    else // 110? ????
    {
        res = (*data++ & 0x1f) << 24;
        res |= *data++ << 16;
        res |= *data++ << 8;
        res |= *data++;
    }

    return res;
}

/**
    Decompresses the data of a signature. (??)

    Params:
    - `data`: Signature to have decompressed.

    Returns:
        4 byte data of `data`.
*/
pure uint corSigUncompressData(ref PCCOR_SIGNATURE data)
{
    // Handle smallest data inline.
    if ((*data & 0x80) == 0x00)        // 0??? ????
        return *data++;

    return corSigUncompressBigData(data);
}

/**
    Tries to decompress a signature entirely.

    Params:
    - `data`: Signature to have decompressed.
    - `len`: Length of `data`.
    - `dataOut`: Data out.
    - `dataLen`: Data length??

    Returns:
        HResult for the success state of decompression.
*/
pure HResult corSigUncompressData(PCCOR_SIGNATURE data, uint len, out uint dataOut, out uint dataLen)
{
    const(ubyte)* bytes = cast(const(ubyte)*)data;

    version(Windows)
    {
        // Smallest.
        if ((data[0] & 0x80) == 0x00) // 0??? ????
        {
            if (len < 1)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.EBadImageFormat;
            }
            else
            {
                dataOut = data[0];
                dataLen = 1;
                return HResult.SOk;
            }
        }
        // Medium.
        else if ((data[0] & 0xC0) == 0x80) // 10?? ????
        {
            if (len < 2)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.EBadImageFormat;
            }
            else
            {
                dataOut = (cast(uint)(data[0] & 0x3F) << 8) | data[1];
                dataLen = 2;
                return HResult.SOk;
            }
        }
        else if ((data[0] & 0xE0) == 0xC0) // 110? ????
        {
            if (len < 4)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.EBadImageFormat;
            }
            else
            {
                dataOut = (cast(uint)(data[0] & 0x1F) << 24) | (cast(uint)data[1] << 16)
                    | (cast(uint)data[2] << 8) | data[3];
                dataLen = 4;
                return HResult.SOk;
            }
        }
        else // We don't recognize this encoding
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.EBadImageFormat;
        }
    }

    // Smallest.
    if ((bytes[0] & 0x80) == 0x00) // 0??? ????
    {
        if (len < 1)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.EBadImageFormat;
        }
        else
        {
            dataOut = bytes[0];
            dataLen = 1;
            return HResult.SOk;
        }
    }
    // Medium.
    else if ((bytes[0] & 0xC0) == 0x80) // 10?? ????
    {
        if (len < 2)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.EBadImageFormat;
        }
        else
        {
            dataOut = (cast(uint)(bytes[0] & 0x3F) << 8) | bytes[1];
            dataLen = 2;
            return HResult.SOk;
        }
    }
    else if ((bytes[0] & 0xE0) == 0xC0) // 110? ????
    {
        if (len < 4)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.EBadImageFormat;
        }
        else
        {
            dataOut = (cast(uint)(bytes[0] & 0x1F) << 24) | (cast(uint)bytes[1] << 16)
                | (cast(uint)bytes[2] << 8) | bytes[3];
            dataLen = 4;
            return HResult.SOk;
        }
    }
    else // We don't recognize this encoding
    {
        dataOut = 0;
        dataLen = 0;
        return HResult.EBadImageFormat;
    }
}

/**
    Decompresses the data of a signature.

    Params:
    - `data`: Signature to have decompressed.
    - `dataOut`: Data out.

    Returns:
        Length of `data`.
*/
pure uint corSigUncompressData(PCCOR_SIGNATURE data, out uint dataOut)
{
    uint dataLen = 0;

    if (corSigUncompressData(data, 0xff, dataOut, dataLen).IsNotOk())
    {
        dataOut = 0;
        return -1;
    }

    return dataLen;
}

/**
    Decodes an encoded token and returns the token type.

    Params:
    - `encoded`: Encoded token.

    Returns:
        Token type of `encoded`.
*/
pure CorTokenType corSigDecodeTokenType(int encoded)
{
    if (encoded == 0)
        return CorTokenType.TypeDef;

    if (encoded == 1)
        return CorTokenType.TypeRef;

    if (encoded == 2)
        return CorTokenType.TypeSpec;

    return CorTokenType.BaseType;
}

/**
   Decompresses a signature and returns the extracted token.

    Params:
    - `data`: Signature to have decompressed.

    Returns:
        MDToken decompressed from `data`.
*/
pure MDToken corSigUncompressToken(ref PCCOR_SIGNATURE data)
{
    MDToken tk = corSigUncompressData(data);
    CorTokenType tkType = corSigDecodeTokenType(tk & 0x3);

    return tokenFromRid(tk >> 2, tkType);
}

/**
    Decompresses a signature and returns the extracted token.

    Params:
    - `data`: Signature to be decompressed.
    - `tk`: MDToken output.

    Returns:
        Length of `data`.
*/
pure uint corSigUncompressToken(PCCOR_SIGNATURE data, out MDToken tk)
{
    uint size = corSigUncompressData(data, tk);
    CorTokenType tkType = corSigDecodeTokenType(tk & 0x3);

    tk = tokenFromRid(tk >> 2, tkType);
    return size;
}

/**
    Tries to decompress a token from a signature.

    Params:
    - `data`: Signature to be decompressed.
    - `len`: Length of `data`.
    - `tk`: MDToken output.
    - `tkLen`: Token length.

    Returns:
        HResult indicating the success state of decompression.
*/
pure HResult corSigUncompressToken(PCCOR_SIGNATURE data, uint len, out MDToken tk, out uint tkLen)
{
    HResult hr = corSigUncompressData(data, len, tk, tkLen);

    if (hr.IsOk())
    {
        CorTokenType tkType = corSigDecodeTokenType(tk & 0x3);
        tk = tokenFromRid(tk >> 2, tkType);
    }
    else
    {
        tk = 0;
    }

    return hr;
}

/**
    Decompresses the calling convention of a signature.

    Params:
    - `data`: Signature to be decompressed.

    Returns:
        Calling convention extracted from the signature.
*/
pure uint corSigUncompressCallingConv(ref PCCOR_SIGNATURE data)
{
    return *data++;
}

/**
    Decompresses the calling convention of a signature.

    Params:
    - `data`: Signature to be decompressed.
    - `len`: Length of `data`.
    - `data`: Data output.

    Returns:
        HResult indicating the success state of decompression.
*/
pure HResult corSigUncompressCallingConv(PCCOR_SIGNATURE data, uint len, out uint data)
{
    if (len <= 0)
    {
        data = 0;
        return HResult.EBadImageFormat;
    }

    return HResult.SOk;
}

/**
    Decompresses a signed integer from a signature.

    Params:
    - `data`: Signature to be decompressed.
    - `value`: Integer output.

    Returns:
        Length of `data`.
*/
pure uint corSigUncompressSignedInt(PCCOR_SIGNATURE data, out int value)
{
    uint data = 0;
    uint size = corSigUncompressData(data, data);

    if (size == -1)
        return size;

    if ((data >>= 1) & 0x1)
    {
        if (size == 1)
        {
            data |= 0xffffffc0;
        }
        else if (size == 2)
        {
            data |= 0xffffe000;
        }
        else
        {
            data |= 0xf0000000;
        }
    }

    value = data;
    return size;
}

/**
    Decompresses an element type from a signature.

    Params:
    - `data`: Signature to be decompressed.

    Returns:
        Decompressed element type from the signature.
*/
pure CorElementType corSigUncompressElementType(ref PCCOR_SIGNATURE data)
{
    return cast(CorElementType)*data++;
}

/**
    Decompresses an element type from a signature.

    Params:
    - `data`: Signature to be decompressed.
    - `elemType`: Element type output.

    Returns:
        Length of `data`.
*/
pure uint corSigUncompressElementType(PCCOR_SIGNATURE data, out CorElementType elemType)
{
    elemType = cast(CorElementType)(*data & 0x7f);
    return 1;
}

/**
    Decompresses a pointer from a signature.

    Params:
    - `data`: Signature to be decompressed.
    - `ptr`: Pointer output.

    Returns:
        Length of `data`.
*/
pure uint corSigUncompressPointer(PCCOR_SIGNATURE data, out void* ptr)
{
    ptr = *cast(void**)data;
    return ptrdiff_t.sizeof;
}