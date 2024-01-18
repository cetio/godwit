/// Represents function pointer stubs & their precode
module godwit.backend.vm.fptrstubs;

import godwit.backend.vm.crst;
import godwit.backend.vm.method;
import godwit.backend.vm.precode;
import godwit.backend.inc.shash;
import caiman.traits;

/**
    Contains stubs that is used by GetMultiCallableAddrOfCode() if
    the function has not been jitted.

    Using a stub decouples ldftn from the prestub, so prestub does not need to be backpatched. \
    This stub is also used in other places which need a function pointer.
*/
public struct FuncPtrStubs
{
public:
final:
    Crst m_hashTableCrst;
    /// To find a existing stub for a method
    SHash!(Precode*, uint) m_hashTable;   

    mixin accessors;
}