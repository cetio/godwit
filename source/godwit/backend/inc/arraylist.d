module godwit.backend.inc.arraylist;

import godwit.impl;

public struct ArrayListBlock
{
public:
final:
    ArrayListBlock* next;
    uint blockSize;
    static if (HOST_x64)
    {
        uint padding;
    }
    void* array;

}

public struct FirstArrayListBlock
{
public:
final:
    ArrayListBlock* next;
    uint blockSize;
    static if (HOST_x64)
    {
        uint padding;
    }
    void*[5] array;

}

public struct ArrayListBase
{
public:
final:
    uint count;
    FirstArrayListBlock firstBlock;

}

public struct ArrayList
{
    ArrayListBase arrayListBase;
    alias arrayListBase this;
}