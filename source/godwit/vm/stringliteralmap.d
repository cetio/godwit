module godwit.stringliteralmap;

import caiman.memorypool;
import godwit.appdomain;
import godwit.eehash;
import caiman.traits;

public struct StringLiteralMap
{
public:
final:
    /// Hash tables that maps a Unicode string to a COM+ string handle.
    EEUnicodeStringLiteralHashTable* m_stringToEntryHashTable;
    /// The memorypool for hash entries for this hash table.
    MemoryPool* m_memoryPool;

    mixin accessors;
}