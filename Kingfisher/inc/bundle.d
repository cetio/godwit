module inc.bundle;

import inc.sbuffer;

public struct BundleFileLocation
{
public:
    long size;
    long offset;
    long uncompressedSize;
}

public struct Bundle
{
public:
    SString path;
    bool function(const char* path, long* offset, long* size, long* compressedSize) probe;
    SString basePath;
    uint basePathLen;
}