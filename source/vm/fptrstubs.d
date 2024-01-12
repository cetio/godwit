/// Represents function pointer stubs & their precode
module godwit.fptrstubs;

import godwit.crst;
import godwit.method;
import godwit.precode;
import godwit.shash;
import godwit.llv.traits;

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