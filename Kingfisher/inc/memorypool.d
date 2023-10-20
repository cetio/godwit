module inc.memorypool;

public struct PoolElement
{
    PoolElement* next;
    /*
#if _DEBUG
		int		deadBeef;
#endif
    */
}

public struct PoolBlock
{
    PoolBlock* next;
    PoolElement* elementsEnd;
    // #ifdef _MSC_VER
    PoolElement[] elements;
}

public struct MemoryPool
{
    size_t elementSize;
    size_t growCount;
    PoolBlock* blocks;
    PoolElement* freeList;
}