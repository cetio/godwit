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
}

public struct ArrayListBase
{
public:
    uint count;
    FirstArrayListBlock firstBlock;
}

public struct ArrayList
{
    ArrayListBase arrayListBase;
    alias arrayListBase this;
}