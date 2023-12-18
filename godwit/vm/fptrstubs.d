module godwit.fptrstubs;

import godwit.crst;
import godwit.method;
import godwit.precode;
import godwit.shash;
import godwit.state;

public struct FuncPtrStubs
{
public:
    Crst m_hashTableCrst;
    // To find a existing stub for a method
    SHash!(Precode*, uint) m_hashTable;   

    mixin accessors;
}