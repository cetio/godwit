/+module readers.pe.metadata;

import std.stdio;
import readers.pe.utils;

/**
* Read the MetaData from the file.
*/
public MetaData readMetaData(File file)
{
    MetaData data;

    file.rawRead(data.Signature);
    file.read(data.MajorVersion);
    file.read(data.MinorVersion);
    file.read(data.Reserved);
    file.read(data.Length);

    data.Version.length = data.Length;
    data.Padding.length = data.Length % 4;
    file.rawRead(data.Version);

    if (data.Padding.length > 0) {
        file.rawRead(data.Padding);
    }

    file.read(data.Flags);
    file.read(data.Streams);

    return data;
}

/**
* Struct to represent the MetaData.
*/
public struct MetaData
{
public:
    char[4] signature;
    ushort majorVersion;
    ushort minorVersion;
    uint reserved;
    uint length;
    char[] medversion;
    ubyte[] padding;
    ushort flags;
    ushort streams;
}+/
