module godwit.memorypool;

import godwit.state;

public struct PoolElement
{
public:
    PoolElement* m_next;
    /*
#if _DEBUG
		int		deadBeef;
#endif
    */
    mixin accessors;
}

public struct PoolBlock
{
public:
    PoolBlock* m_next;
    PoolElement* m_elementsEnd;
    // #ifdef _MSC_VER
    PoolElement[] m_elements;

    mixin accessors;
}

public struct MemoryPool
{
public:
    size_t m_elementSize;
    size_t m_growCount;
    PoolBlock* m_blocks;
    PoolElement* m_freeList;

    mixin accessors;
}