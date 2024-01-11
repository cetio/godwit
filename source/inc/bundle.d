module godwit.bundle;

import godwit.sbuffer;
import godwit.mem.state;

public struct BundleFileLocation
{
public:
    long m_size;
    long m_offset;
    long m_uncompressedSize;

    mixin accessors;
}

public struct Bundle
{
public:
    SString m_path;
    // TODO: This todo exists to mark that this is intentionally not part of the accessor gen.
    bool function(const char* path, long* offset, long* size, long* compressedSize) probe;
    SString m_basePath;
    uint m_basePathLen;

    mixin accessors;
}