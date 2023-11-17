module vm.fptrstubs;

import vm.crst;
import vm.method;
import vm.precode;
import inc.shash;

public struct FuncPtrStubs
{
public:
    Crst hashTableCrst;
    // To find a existing stub for a method
    SHash!(Precode*, uint) hashTable;    
    
    Crst getHashTableCrst()
    {
        return hashTableCrst;
    }
}