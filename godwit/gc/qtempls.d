/// Represents what should be godwit.corhlprpriv
module godwit.qtempls;

import godwit.state;

public struct CQuickMemoryBase
{
public:
    byte* m_buffer;
    // number of bytes used
    size_t m_size;
    // total bytes allocated in the buffer
    size_t m_totalAlloc;
    ulong[(511 + ulong.sizeof) / ulong.sizeof] m_data; // (512+sizeof(UINT64)-1)/sizeof(UINT64)

    mixin accessors;
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
    size_t m_curSize;

    mixin accessors;
}