module vm.fptrstubs;

import vm.crst;
import vm.method;
import vm.precode;
import inc.shash;
import state;

public struct FuncPtrStubs
{
public:
    Crst m_hashTableCrst;
    // To find a existing stub for a method
    SHash!(Precode*, uint) m_hashTable;   

    mixin accessors;
}