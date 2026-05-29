module godwit.backend.inc.memorypool;

import godwit.impl;

public struct PoolElement
{
public:
final:
    PoolElement* next;
    static if (DEBUG)
    {
        int deadBeef;
    }

}

public struct PoolBlock
{
public:
final:
    PoolBlock* next;
    PoolElement* elementsEnd;
    PoolElement* elements;

}

public struct MemoryPool
{
public:
final:
    size_t elementSize;
    size_t growCount;
    PoolBlock* blocks;
    PoolElement* freeList;

}