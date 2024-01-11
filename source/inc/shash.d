module godwit.shash;

import godwit.llv.traits;
import godwit.nativeimage;
import godwit.assembly;
import godwit.applicationcontext;

public struct SHash(ELEM, COUNT)
{
public:
    ELEM* m_table;
    COUNT m_size;
    COUNT m_count;
    COUNT m_occupied;
    COUNT m_max;

    mixin accessors;
}