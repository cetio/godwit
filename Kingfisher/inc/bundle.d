module inc.bundle;

import inc.sbuffer;

public struct BundleFileLocation
{
public:
    long size;
    long offset;
    long uncompressedSize;

    long getSize()
    {
        return size;
    }

    void setSize(long newSize)
    {
        size = newSize;
    }

    long getOffset()
    {
        return offset;
    }

    void setOffset(long newOffset)
    {
        offset = newOffset;
    }

    long getUncompressedSize()
    {
        return uncompressedSize;
    }

    void setUncompressedSize(long newUncompressedSize)
    {
        uncompressedSize = newUncompressedSize;
    }
}

public struct Bundle
{
public:
    SString path;
    bool function(const char* path, long* offset, long* size, long* compressedSize) probe;
    SString basePath;
    uint basePathLen;

    SString getPath()
    {
        return path;
    }

    void setPath(SString newPath)
    {
        path = newPath;
    }

    bool function(const char* path, long* offset, long* size, long* compressedSize) getProbe()
    {
        return probe;
    }

    void setProbe(bool function(const char* path, long* offset, long* size, long* compressedSize) newProbe)
    {
        probe = newProbe;
    }

    SString getBasePath()
    {
        return basePath;
    }

    void setBasePath(SString newBasePath)
    {
        basePath = newBasePath;
    }

    uint getBasePathLen()
    {
        return basePathLen;
    }

    void setBasePathLen(uint newBasePathLen)
    {
        basePathLen = newBasePathLen;
    }
}