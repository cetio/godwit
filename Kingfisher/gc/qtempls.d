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
    ulong[(511 + ulong.sizeof) / ulong.sizeof] data; // (512+sizeof(UINT64)-1)/sizeof(UINT64)

    byte* getBuffer()
    {
        return buffer;
    }

    void setBuffer(byte* newBuffer)
    {
        buffer = newBuffer;
    }

    size_t getSize()
    {
        return size;
    }

    void setSize(size_t newSize)
    {
        size = newSize;
    }

    size_t getTotalAlloc()
    {
        return totalAlloc;
    }

    void setTotalAlloc(size_t newTotalAlloc)
    {
        totalAlloc = newTotalAlloc;
    }

    ulong[(511 + ulong.sizeof) / ulong.sizeof] getData()
    {
        return data;
    }

    void setData(ulong[(511 + ulong.sizeof) / ulong.sizeof] newData)
    {
        data = newData.dup;
    }
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

    size_t getCurSize()
    {
        return curSize;
    }

    void setCurSize(size_t newCurSize)
    {
        curSize = newCurSize;
    }
}