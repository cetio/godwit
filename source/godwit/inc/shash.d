module godwit.shash;

import caiman.traits;
import godwit.nativeimage;
import godwit.assembly;
import godwit.applicationcontext;

public struct SHash(ELEM, COUNT)
{
public:
final:
    ELEM* m_table;
    COUNT m_size;
    COUNT m_count;
    COUNT m_occupied;
    COUNT m_max;

    mixin accessors;
}