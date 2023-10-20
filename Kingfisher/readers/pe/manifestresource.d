/+module readers.pe.manifestresource;

import std.stdio;
import std.conv;
import readers.pe.utils;

public struct ManifestResource 
{
public:
    uint offset;
    uint flags;
    ushort nameOffset;
    ushort implementation;

    bool isInternalResource() 
    {
        return implementation == 0;
    }
}+/