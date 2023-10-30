module vm.stringliteralmap;

import inc.memorypool;
import vm.appdomain;

public struct StringLiteralMap
{
public:
    // -----> EEUnicodeStringLiteralHashTable* <-----
    // Hash tables that maps a Unicode string to a COM+ string handle.
    void* stringToEntryHashTable;
    // The memorypool for hash entries for this hash table.
    MemoryPool* memoryPool;
}