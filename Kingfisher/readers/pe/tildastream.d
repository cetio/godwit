/+module readers.pe.tildastream;

import std.stdio;
import core.bitop;
import readers.pe.utils;

public TildaStream readTildaStream(File f) 
{
    TildaStream stream;

    with (stream) {
        f.read(reserved);
        f.read(majorVersion);
        f.read(minorVersion);
        f.read(heapSizes);
        f.read(reserved2);
        f.read(valid);
        f.read(sorted);

        for(auto i = 0; i < RowSizes.length; i++) {
            if (hasTable(i)) {
                rows ~= f.readuint;
            }
            else {
                rows ~= 0;
            }
        }
    }

    return stream;
}

public struct TildaStream
{  
public:
    enum RowSizes = [10,6,14,2,6,2,14,2,6,4,6,6,6,4,6,8,6,2,4,2,6,4,2,6,6,6,2,2,8,6,8,4,22,4,12,20,6,14,8,14,12,4];

    uint reserved;
    ubyte majorVersion;
    ubyte minorVersion;
    ubyte heapSizes;
    ubyte reserved2;
    ulong valid;
    ulong sorted;
    uint[] rows;

    bool hasTable(int i) {
        return (valid & (1UL << i)) != 0;
    }
    uint tableSize(int i) {
        return rows[i] * RowSizes[i];
    }
}+/