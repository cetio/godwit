module godwit.backend.inc.shash;

import caiman.traits;
import godwit.backend.vm.nativeimage;
import godwit.backend.vm.assembly;
import godwit.backend.binder.applicationcontext;

public struct SHash(ELEM, COUNT)
{
public:
final:
    ELEM* m_table;
    COUNT m_size;
    COUNT m_count;
    COUNT m_occupied;
    COUNT m_max;

    //mixin accessors;
}