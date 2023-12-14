module vm.stringliteralmap;

import inc.memorypool;
import vm.appdomain;
import vm.eehash;

public struct StringLiteralMap
{
public:
    // Hash tables that maps a Unicode string to a COM+ string handle.
    EEUnicodeStringLiteralHashTable* stringToEntryHashTable;
    // The memorypool for hash entries for this hash table.
    MemoryPool* memoryPool;

    EEUnicodeStringLiteralHashTable* getStringToEntryHashTable()
    {
        return stringToEntryHashTable;
    }

    MemoryPool* getMemoryPool()
    {
        return memoryPool;
    }

    void setStringToEntryHashTable(EEUnicodeStringLiteralHashTable* newStringToEntryHashTable)
    {
        stringToEntryHashTable = newStringToEntryHashTable;
    }

    void setMemoryPool(MemoryPool* newMemoryPool)
    {
        memoryPool = newMemoryPool;
    }
}