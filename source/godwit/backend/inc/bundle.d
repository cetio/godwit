module godwit.backend.inc.bundle;

import godwit.backend.inc.sbuffer;

public struct BundleFileLocation
{
public:
final:
    long m_size;
    long m_offset;
    long m_uncompressedSize;

}

public struct Bundle
{
public:
final:
    SString m_path;
    bool function(const(char)* path, long* offset, long* size, long* compressedSize) probe;
    SString m_basePath;
    uint m_basePathLen;

}