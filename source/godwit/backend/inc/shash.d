module godwit.backend.inc.shash;

import godwit.backend.vm.nativeimage;
import godwit.backend.vm.assembly;
import godwit.backend.binder.applicationcontext;

public struct SHash(ELEM, COUNT)
{
public:
final:
    ELEM* table;
    COUNT size;
    COUNT count;
    COUNT occupied;
    COUNT max;

    //mixin accessors;
}