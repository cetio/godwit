module godwit.cor;

import godwit.corhdr;
import godwit.state;

/*
This file does not include any compression, only decompression
You can see the omitted functions at https://github.com/dotnet/runtime/blob/main/src/coreclr/inc/cor.h
- uint CorSigCompressData(uint, void*)
- uint CorSigCompressToken(MDToken, void*)
- uint CorSigCompressSignedInt(int, void*)
- uint CorSigCompressElementType(out CorElementType, void*)
- uint CorSigCompressPointer(void*, void*)
*/

public:
static:
RID RidToToken(RID rid, CorTokenType tkType)
{
    return rid |= tkType;
}

MDToken TokenFromRid(RID rid, CorTokenType tkType)
{
    return rid | tkType;
}

RID RidFromToken(MDToken tk)
{
    return tk & 0x00ffffff;
}

uint TypeFromToken(MDToken tk)
{
    return tk & 0xff000000;
}

bool IsNilToken(MDToken tk)
{
    return RidFromToken(tk) == 0;
}

bool CorIsPrimitiveType(CorElementType elemType)
{
    return elemType < CorElementType.Ptr || elemType == CorElementType.NInt || elemType == CorElementType.NUInt;
}

public bool CorIsModifierElementType(CorElementType elemType)
{
    if (elemType == CorElementType.Ptr || elemType == CorElementType.ByRef)
        return true;

    return (elemType & CorElementType.Modifier) != 0;
}

public uint CorSigUncompressedDataSize(PCCOR_SIGNATURE pData)
{
    if ((pData[0] & 0x80) == 0)
        return 1;

    if ((pData[0] & 0xC0) == 0x80)
        return 2;

    return 4;
}

uint CorSigUncompressBigData(ref PCCOR_SIGNATURE pData)
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

uint CorSigUncompressData(ref PCCOR_SIGNATURE pData)
{
    // Handle smallest data inline.
    if ((*pData & 0x80) == 0x00)        // 0??? ????
        return *pData++;

    return CorSigUncompressBigData(pData);
}

HResult CorSigUncompressData(PCCOR_SIGNATURE pData, uint len, out uint dataOut, out uint dataLen)
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

uint CorSigUncompressData(PCCOR_SIGNATURE pData, out uint dataOut)
{
    uint dataLen = 0;

    if (CorSigUncompressData(pData, 0xff, dataOut, dataLen).NOTOK)
    {
        dataOut = 0;
        return -1;
    }

    return dataLen;
}

CorTokenType CorSigDecodeTokenType(int encoded)
{
    if (encoded == 0)
        return CorTokenType.TypeDef;

    if (encoded == 1)
        return CorTokenType.TypeRef;

    if (encoded == 2)
        return CorTokenType.TypeSpec;

    return CorTokenType.BaseType;
}

MDToken CorSigUncompressToken(ref PCCOR_SIGNATURE pData)
{
    MDToken tk = CorSigUncompressData(pData);
    CorTokenType tkType = CorSigDecodeTokenType(tk & 0x3);

    return TokenFromRid(tk >> 2, tkType);
}

uint CorSigUncompressToken(PCCOR_SIGNATURE pData, out MDToken tk)
{
    uint size = CorSigUncompressData(pData, tk);
    CorTokenType tkType = CorSigDecodeTokenType(tk & 0x3);

    tk = TokenFromRid(tk >> 2, tkType);
    return size;
}

HResult CorSigUncompressToken(PCCOR_SIGNATURE pData, uint len, out MDToken tk, out uint tkLen)
{
    HResult hr = CorSigUncompressData(pData, len, tk, tkLen);

    if (hr.OK())
    {
        CorTokenType tkType = CorSigDecodeTokenType(tk & 0x3);
        tk = TokenFromRid(tk >> 2, tkType);
    }
    else
    {
        tk = 0;
    }

    return hr;
}

uint CorSigUncompressCallingConv(ref PCCOR_SIGNATURE pData)
{
    return *pData++;
}

HResult CorSigUncompressCallingConv(PCCOR_SIGNATURE pData, uint dwLen, out uint data)
{
    if (dwLen <= 0)
    {
        data = 0;
        return HResult.E_BADIMAGEFORMAT; 
    }

    return HResult.S_OK;
}

uint CorSigUncompressSignedInt(PCCOR_SIGNATURE pData, out int value)
{
    uint data = 0;
    uint size = CorSigUncompressData(pData, data);

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

CorElementType CorSigUncompressElementType(ref PCCOR_SIGNATURE pData)
{
    return cast(CorElementType)*pData++;
}

uint CorSigUncompressElementType(PCCOR_SIGNATURE pData, out CorElementType elemType)
{
    elemType = cast(CorElementType)(*pData & 0x7f);
    return 1;
}

uint CorSigUncompressPointer(PCCOR_SIGNATURE pData, out void* ptr)
{
    ptr = *cast(void**)pData;
    return ptrdiff_t.sizeof;
}