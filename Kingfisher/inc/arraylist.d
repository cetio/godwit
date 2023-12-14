module inc.arraylist;

public struct ArrayListBlock
{
public:
    ArrayListBlock* next;
    uint blockSize;
    // #ifdef HOST_64BIT
    version (X86_64)
    {
        uint padding;
    }
    void* array;

    ArrayListBlock* getNext()
    {
        return next;
    }

    void setNext(ArrayListBlock* newNext)
    {
        next = newNext;
    }

    uint getBlockSize()
    {
        return blockSize;
    }

    void setBlockSize(uint newBlockSize)
    {
        blockSize = newBlockSize;
    }

    void* getArray()
    {
        return array;
    }

    void setArray(void* newArray)
    {
        array = newArray;
    }
}

public struct FirstArrayListBlock
{
public:
    ArrayListBlock* next;
    uint blockSize;
    // #ifdef HOST_64BIT
    version (X86_64)
    {
        uint padding;
    }
    void*[5] array;

    ArrayListBlock* getNext()
    {
        return next;
    }

    void setNext(ArrayListBlock* newNext)
    {
        next = newNext;
    }

    uint getBlockSize()
    {
        return blockSize;
    }

    void setBlockSize(uint newBlockSize)
    {
        blockSize = newBlockSize;
    }

    void*[] getArray()
    {
        return array;
    }

    void setArray(void*[] newArray)
    {
        array = newArray.dup;
    }
}

public struct ArrayListBase
{
public:
    uint count;
    FirstArrayListBlock firstBlock;

    uint getCount()
    {
        return count;
    }

    void setCount(uint newCount)
    {
        count = newCount;
    }

    FirstArrayListBlock getFirstBlock()
    {
        return firstBlock;
    }

    void setFirstBlock(FirstArrayListBlock newFirstBlock)
    {
        firstBlock = newFirstBlock;
    }
}

public struct ArrayList
{
    ArrayListBase arrayListBase;
    alias arrayListBase this;
}