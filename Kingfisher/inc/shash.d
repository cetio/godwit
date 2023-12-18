module inc.shash;

import state;
import vm.nativeimage;
import binder.assembly;
import binder.applicationcontext;

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