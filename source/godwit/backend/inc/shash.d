module godwit.backend.shash;

import caiman.traits;
import godwit.backend.nativeimage;
import godwit.backend.assembly;
import godwit.backend.applicationcontext;

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