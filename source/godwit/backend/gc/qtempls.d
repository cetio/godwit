/// Represents what should be godwit.corhlprpriv
module godwit.backend.gc.qtempls;


public struct CQuickMemoryBase
{
public:
final:
    byte* buffer;
    /// Number of bytes used
    size_t size;
    /// Total bytes allocated in the buffer
    size_t totalAlloc;
    ulong[(511 + ulong.sizeof) / ulong.sizeof] data; // (512+sizeof(UINT64)-1)/sizeof(UINT64)

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
final:
    size_t curSize;

}