module inc.memorypool;

public struct PoolElement
{
public:
    PoolElement* next;
    /*
#if _DEBUG
		int		deadBeef;
#endif
    */
    PoolBlock* getNext()
    {
        return next;
    }

    void setNext(PoolBlock* newNext)
    {
        next = newNext;
    }
}

public struct PoolBlock
{
public:
    PoolBlock* next;
    PoolElement* elementsEnd;
    // #ifdef _MSC_VER
    PoolElement[] elements;

    PoolBlock* getNext()
    {
        return next;
    }

    void setNext(PoolBlock* newNext)
    {
        next = newNext;
    }

    PoolElement* getElementsEnd()
    {
        return elementsEnd;
    }

    void setElementsEnd(PoolElement* newElementsEnd)
    {
        elementsEnd = newElementsEnd;
    }

    PoolElement[] getElements()
    {
        return elements.dup;
    }

    void setElements(PoolElement[] newElements)
    {
        elements = newElements.dup;
    }
}

public struct MemoryPool
{
public:
    size_t elementSize;
    size_t growCount;
    PoolBlock* blocks;
    PoolElement* freeList;

    size_t getElementSize()
    {
        return elementSize;
    }

    void setElementSize(size_t newElementSize)
    {
        elementSize = newElementSize;
    }

    size_t getGrowCount()
    {
        return growCount;
    }

    void setGrowCount(size_t newGrowCount)
    {
        growCount = newGrowCount;
    }

    PoolBlock* getBlocks()
    {
        return blocks;
    }

    void setBlocks(PoolBlock* newBlocks)
    {
        blocks = newBlocks;
    }

    PoolElement* getFreeList()
    {
        return freeList;
    }

    void setFreeList(PoolElement* newFreeList)
    {
        freeList = newFreeList;
    }
}