module inc.sbuffer;

public struct SBuffer
{
public:
    enum Representation {
        Empty = 0x00,
        Unicode = 0x04,
        ASCII = 0x01,
        UTF8 = 0x03,
        VariableMask = 0x02,
        SingleMask = 0x01,
        Mask = 0x07
    }

    enum State
    {
        Allocated = 0x08,
        Immutable = 0x10,
        Opened = 0x20,
        Flag1 = 0x40,
        Flag2 = 0x80,
        Flag3 = 0x100,
    };

    size_t size;
    size_t allocSize;
    State flags;
    union
    {
        ubyte* m_buffer;
        wchar* m_asStr;
    }

    bool isAllocated()
    {
        return (flags & State.Allocated) != 0;
    }

    bool isImmutable()
    {
        return (flags & State.Immutable) != 0;
    }

    bool isOpened()
    {
        return (flags & State.Opened) != 0;
    }

    bool hasFlag1()
    {
        return (flags & State.Flag1) != 0;
    }

    bool hasFlag2()
    {
        return (flags & State.Flag2) != 0;
    }

    bool hasFlag3()
    {
        return (flags & State.Flag3) != 0;
    }
}

// Represents inc.sstring

public struct SString
{
    SBuffer sbuffer;
    alias sbuffer this;

public:
    bool isEmpty()
    {
        return (flags & Representation.Mask) == Representation.Empty;
    }

    bool isUnicode()
    {
        return (flags & Representation.Mask) == Representation.Unicode;
    }

    bool isASCII()
    {
        return (flags & Representation.Mask) == Representation.ASCII;
    }

    bool isUTF8()
    {
        return (flags & Representation.Mask) == Representation.UTF8;
    }
}

// Represents inc.sarray

public struct SArray(T)
{
public:
    SBuffer buffer;
}