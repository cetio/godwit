module gc.qtempls;

// Represents what should be inc.corhlprpriv

public struct CQuickMemoryBase
{
public:
    byte* buffer;
    // number of bytes used
    size_t size;
    // total bytes allocated in the buffer
    size_t totalAlloc;
    ulong[64] data; // (512+sizeof(UINT64)-1)/sizeof(UINT64)
}

public struct CQuickBytesBase
{
    CQuickMemoryBase cquickMemoryBase;
    alias cquickMemoryBase this;
}

public struct CQuickBytes
{
    CQuickBytesBase cquickBytesBase;
    alias cquickBytesBase this;
}

public struct CQuickBytesStatic
{
    CQuickBytesBase cquickBytesBase;
    alias cquickBytesBase this;
}

public struct CQuickArrayBase(T)
{
    CQuickBytesBase cquickBytesBase;
    alias cquickBytesBase this;
}

public struct CQuickArray(T)
{
    CQuickArrayBase!T cquickArrayBase;
    alias cquickArrayBase this;
}

public struct CQuickArrayList(T)
{
    CQuickArray!T cquickArray;
    alias cquickArray this;

public:
    size_t curSize;
}