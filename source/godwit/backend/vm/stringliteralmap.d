module godwit.backend.vm.stringliteralmap;

import godwit.backend.inc.memorypool;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.eehash;

public struct StringLiteralMap
{
public:
final:
    /// Hash tables that maps a Unicode string to a COM+ string handle.
    EEUnicodeStringLiteralHashTable* stringToEntryHashTable;
    /// The memorypool for hash entries for this hash table.
    MemoryPool* memoryPool;

}