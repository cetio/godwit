/+module readers.pe.streamheader;

import std.stdio;
import readers.pe.utils;

/**
* Read a stream header from the file.
*/
public StreamHeader readStreamHeader(File file)
{
    StreamHeader header;
    file.read(header.offset);
    file.read(header.size);

    // Read null-terminated, 4-byte padded string
    while (true) {
        ubyte[4] buf;
        file.rawRead(buf);
        header.name ~= cast(char[])buf;

        if (buf[3] == 0) {
            break;
        }
    }

    return header;
}

/**
* Read an array of stream headers from the file.
*/
public StreamHeader[] readStreamHeaders(File file, int numOfStreams)
{
    StreamHeader[] headers;
    headers.reserve(numOfStreams);

    foreach (i; 0..numOfStreams)
    {
        headers ~= readStreamHeader(file);
    }

    return headers;
}

/**
* Struct to represent a stream header.
*/
public struct StreamHeader
{
public:
    uint offset;
    uint size;
    char[] name;
}+/