module godwit.backend.inc.memorypool;

import godwit.impl;

public struct PoolElement
{
public:
final:
    PoolElement* m_next;
    static if (DEBUG)
    {
        int deadBeef;
    }

}

public struct PoolBlock
{
public:
final:
    PoolBlock* m_next;
    PoolElement* m_elementsEnd;
    PoolElement* m_elements;

}

public struct MemoryPool
{
public:
final:
    size_t m_elementSize;
    size_t m_growCount;
    PoolBlock* m_blocks;
    PoolElement* m_freeList;

}