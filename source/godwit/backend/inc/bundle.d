module godwit.backend.inc.bundle;

import godwit.backend.inc.sbuffer;

public struct BundleFileLocation
{
public:
final:
    long size;
    long offset;
    long uncompressedSize;

}

public struct Bundle
{
public:
final:
    SString path;
    bool function(const(char)* path, long* offset, long* size, long* compressedSize) probe;
    SString basePath;
    uint basePathLen;

}