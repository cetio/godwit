module godwit.arraylist;

import caiman.traits;
import godwit.impl;

public struct ArrayListBlock
{
public:
final:
    ArrayListBlock* m_next;
    uint m_blockSize;
    static if (HOST_x64)
    {
        uint padding;
    }
    void* m_array;

    mixin accessors;
}

public struct FirstArrayListBlock
{
public:
final:
    ArrayListBlock* next;
    uint m_blockSize;
    static if (HOST_x64)
    {
        uint padding;
    }
    void*[5] m_array;

    mixin accessors;
}

public struct ArrayListBase
{
public:
final:
    uint m_count;
    FirstArrayListBlock m_firstBlock;

    mixin accessors;
}

public struct ArrayList
{
    ArrayListBase arrayListBase;
    alias arrayListBase this;
}