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
    uint* probe;
    SString basePath;
    size_t basePathLen;
}