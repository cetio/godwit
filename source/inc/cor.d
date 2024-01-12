/// Provides functions for working with signatures and their data.
///
/// Very confusing, so some documentation may not be very helpful.
module godwit.cor;

import godwit.corhdr;
import godwit.llv.traits;
import godwit.mem.state;

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
    - `pData`: Signature to have decompressed.

    Returns:
        Data size of `pData`.
*/
pure uint corSigUncompressedDataSize(PCCOR_SIGNATURE pData)
{
    if ((pData[0] & 0x80) == 0)
        return 1;

    if ((pData[0] & 0xC0) == 0x80)
        return 2;

    return 4;
}

/**
    Decompresses big data from a signature.

    Params:
    - `pData`: Signature to be decompressed.

    Returns:
        Decompressed big data from the signature.
*/
pure uint corSigUncompressBigData(ref PCCOR_SIGNATURE pData)
{
    uint res;

    // Medium.
    if ((*pData & 0xC0) == 0x80)  // 10?? ????
    {
        res = cast(uint)((*pData++ & 0x3f) << 8);
        res |= *pData++;
    }
    else // 110? ????
    {
        res = (*pData++ & 0x1f) << 24;
        res |= *pData++ << 16;
        res |= *pData++ << 8;
        res |= *pData++;
    }

    return res;
}

/**
    Decompresses the data of a signature. (??)

    Params:
    - `pData`: Signature to have decompressed.

    Returns:
        4 byte data of `pData`.
*/
pure uint corSigUncompressData(ref PCCOR_SIGNATURE pData)
{
    // Handle smallest data inline.
    if ((*pData & 0x80) == 0x00)        // 0??? ????
        return *pData++;

    return corSigUncompressBigData(pData);
}

/**
    Tries to decompress a signature entirely.

    Params:
    - `pData`: Signature to have decompressed.
    - `len`: Length of `pData`.
    - `dataOut`: Data out.
    - `dataLen`: Data length??

    Returns:
        HResult for the success state of decompression.
*/
pure HResult corSigUncompressData(PCCOR_SIGNATURE pData, uint len, out uint dataOut, out uint dataLen)
{
    const(ubyte)* pBytes = cast(const(ubyte)*)pData;

    version(Windows)
    {
        // Smallest.
        if ((pData[0] & 0x80) == 0x00) // 0??? ????
        {
            if (len < 1)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.E_BADIMAGEFORMAT;
            }
            else
            {
                dataOut = pData[0];
                dataLen = 1;
                return HResult.S_OK;
            }
        }
        // Medium.
        else if ((pData[0] & 0xC0) == 0x80) // 10?? ????
        {
            if (len < 2)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.E_BADIMAGEFORMAT;
            }
            else
            {
                dataOut = (cast(uint)(pData[0] & 0x3F) << 8) | pData[1];
                dataLen = 2;
                return HResult.S_OK;
            }
        }
        else if ((pData[0] & 0xE0) == 0xC0) // 110? ????
        {
            if (len < 4)
            {
                dataOut = 0;
                dataLen = 0;
                return HResult.E_BADIMAGEFORMAT;
            }
            else
            {
                dataOut = (cast(uint)(pData[0] & 0x1F) << 24) | (cast(uint)pData[1] << 16) | (cast(uint)pData[2] << 8) | pData[3];
                dataLen = 4;
                return HResult.S_OK;
            }
        }
        else // We don't recognize this encoding
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.E_BADIMAGEFORMAT;
        }
    }

    // Smallest.
    if ((pBytes[0] & 0x80) == 0x00) // 0??? ????
    {
        if (len < 1)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.E_BADIMAGEFORMAT;
        }
        else
        {
            dataOut = pBytes[0];
            dataLen = 1;
            return HResult.S_OK;
        }
    }
    // Medium.
    else if ((pBytes[0] & 0xC0) == 0x80) // 10?? ????
    {
        if (len < 2)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.E_BADIMAGEFORMAT;
        }
        else
        {
            dataOut = (cast(uint)(pBytes[0] & 0x3F) << 8) | pBytes[1];
            dataLen = 2;
            return HResult.S_OK;
        }
    }
    else if ((pBytes[0] & 0xE0) == 0xC0) // 110? ????
    {
        if (len < 4)
        {
            dataOut = 0;
            dataLen = 0;
            return HResult.E_BADIMAGEFORMAT;
        }
        else
        {
            dataOut = (cast(uint)(pBytes[0] & 0x1F) << 24) | (cast(uint)pBytes[1] << 16) | (cast(uint)pBytes[2] << 8) | pBytes[3];
            dataLen = 4;
            return HResult.S_OK;
        }
    }
    else // We don't recognize this encoding
    {
        dataOut = 0;
        dataLen = 0;
        return HResult.E_BADIMAGEFORMAT;
    }
}

/**
    Decompresses the data of a signature.

    Params:
    - `pData`: Signature to have decompressed.
    - `dataOut`: Data out.

    Returns:
        Length of `pData`.
*/
pure uint corSigUncompressData(PCCOR_SIGNATURE pData, out uint dataOut)
{
    uint dataLen = 0;

    if (corSigUncompressData(pData, 0xff, dataOut, dataLen).NOTOK)
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
    - `pData`: Signature to have decompressed.

    Returns:
        MDToken decompressed from `pData`.
*/
pure MDToken corSigUncompressToken(ref PCCOR_SIGNATURE pData)
{
    MDToken tk = corSigUncompressData(pData);
    CorTokenType tkType = corSigDecodeTokenType(tk & 0x3);

    return tokenFromRid(tk >> 2, tkType);
}

/**
    Decompresses a signature and returns the extracted token.

    Params:
    - `pData`: Signature to be decompressed.
    - `tk`: MDToken output.

    Returns:
        Length of `pData`.
*/
pure uint corSigUncompressToken(PCCOR_SIGNATURE pData, out MDToken tk)
{
    uint size = corSigUncompressData(pData, tk);
    CorTokenType tkType = corSigDecodeTokenType(tk & 0x3);

    tk = tokenFromRid(tk >> 2, tkType);
    return size;
}

/**
    Tries to decompress a token from a signature.

    Params:
    - `pData`: Signature to be decompressed.
    - `len`: Length of `pData`.
    - `tk`: MDToken output.
    - `tkLen`: Token length.

    Returns:
        HResult indicating the success state of decompression.
*/
pure HResult corSigUncompressToken(PCCOR_SIGNATURE pData, uint len, out MDToken tk, out uint tkLen)
{
    HResult hr = corSigUncompressData(pData, len, tk, tkLen);

    if (hr.OK())
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
    - `pData`: Signature to be decompressed.

    Returns:
        Calling convention extracted from the signature.
*/
pure uint corSigUncompressCallingConv(ref PCCOR_SIGNATURE pData)
{
    return *pData++;
}

/**
    Decompresses the calling convention of a signature.

    Params:
    - `pData`: Signature to be decompressed.
    - `dwLen`: Length of `pData`.
    - `data`: Data output.

    Returns:
        HResult indicating the success state of decompression.
*/
pure HResult corSigUncompressCallingConv(PCCOR_SIGNATURE pData, uint dwLen, out uint data)
{
    if (dwLen <= 0)
    {
        data = 0;
        return HResult.E_BADIMAGEFORMAT; 
    }

    return HResult.S_OK;
}

/**
    Decompresses a signed integer from a signature.

    Params:
    - `pData`: Signature to be decompressed.
    - `value`: Integer output.

    Returns:
        Length of `pData`.
*/
pure uint corSigUncompressSignedInt(PCCOR_SIGNATURE pData, out int value)
{
    uint data = 0;
    uint size = corSigUncompressData(pData, data);

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
    - `pData`: Signature to be decompressed.

    Returns:
        Decompressed element type from the signature.
*/
pure CorElementType corSigUncompressElementType(ref PCCOR_SIGNATURE pData)
{
    return cast(CorElementType)*pData++;
}

/**
    Decompresses an element type from a signature.

    Params:
    - `pData`: Signature to be decompressed.
    - `elemType`: Element type output.

    Returns:
        Length of `pData`.
*/
pure uint corSigUncompressElementType(PCCOR_SIGNATURE pData, out CorElementType elemType)
{
    elemType = cast(CorElementType)(*pData & 0x7f);
    return 1;
}

/**
    Decompresses a pointer from a signature.

    Params:
    - `pData`: Signature to be decompressed.
    - `ptr`: Pointer output.

    Returns:
        Length of `pData`.
*/
pure uint corSigUncompressPointer(PCCOR_SIGNATURE pData, out void* ptr)
{
    ptr = *cast(void**)pData;
    return ptrdiff_t.sizeof;
}