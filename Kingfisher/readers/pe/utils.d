/+module readers.pe.utils;

import std.stdio;
import std.array;
import std.conv;
import std.range;

public T readValue(T)(File file)
{
    T value;
    file.rawRead(value);
    return value;
}

public ulong read7BitEncodedInteger(File file)
{
    ulong result = 0;
    int shift = 0;

    while (true)
    {
        ubyte b;
        file.rawRead((&b)[0..1]);
        result |= cast(ulong)(b & 0x7F) << shift;
        shift += 7;

        if ((b & 0x80) == 0)
        {
            break;
        }
    }

    return result;
}

public byte[] readBlob(File file)
{
    auto length = file.read7BitEncodedInteger;
    byte[] buffer = new byte[](cast(uint)length);
    file.rawRead(buffer);
    return buffer;
}

public string readString(File file)
{
    auto length = file.read7BitEncodedInteger;
    return cast(string)file.readln(length);
}

public char[] toChars(byte[] bytes)
{
    return bytes.map!(b => cast(char)b).array;
}+/