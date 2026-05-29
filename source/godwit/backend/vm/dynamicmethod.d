module godwit.backend.vm.dynamicmethod;

import godwit.backend.vm.crst;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.method;

public struct DynamicMethodTable
{
public:
final:
    CrstExplicitInit crst;
    DynamicMethodDesc* dynamicMethodList;
    MethodTable* methodTable;
    Module* ceemodule;
    AppDomain* domain;

}