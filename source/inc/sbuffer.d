module godwit.sbuffer;

import godwit.collections.state;

public struct SBuffer
{
public:
    @flags enum Representation {
        Empty = 0x00,
        Unicode = 0x04,
        ASCII = 0x01,
        UTF8 = 0x03,
        VariableMask = 0x02,
        SingleMask = 0x01,
        Mask = 0x07
    }

    @Representation @flags enum State
    {
        Allocated = 0x08,
        Immutable = 0x10,
        Opened = 0x20,
        Flag1 = 0x40,
        Flag2 = 0x80,
        Flag3 = 0x100,
    }

    size_t m_size;
    size_t m_allocSize;
    State m_flags;
    union
    {
        ubyte* m_buffer;
        wchar* m_asString;
    }

    mixin accessors;
}

// Represents godwit.sstring

public struct SString
{
    SBuffer sbuffer;
    alias sbuffer this;
}

// Represents godwit.sarray

public struct SArray(T)
{
public:
    SBuffer buffer;

    mixin accessors;
}