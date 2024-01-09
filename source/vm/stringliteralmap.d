module godwit.stringliteralmap;

import godwit.memorypool;
import godwit.appdomain;
import godwit.eehash;
import godwit.mem.state;

public struct StringLiteralMap
{
public:
    // Hash tables that maps a Unicode string to a COM+ string handle.
    EEUnicodeStringLiteralHashTable* m_stringToEntryHashTable;
    // The memorypool for hash entries for this hash table.
    MemoryPool* m_memoryPool;

    mixin accessors;
}