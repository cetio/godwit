module godwit.backend.vm.dynamicmethod;

import godwit.backend.vm.crst;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.method;
import caiman.traits;

public struct DynamicMethodTable
{
public:
final:
    CrstExplicitInit m_crst;
    DynamicMethodDesc* m_dynamicMethodList;
    MethodTable* m_methodTable;
    Module* m_ceemodule;
    AppDomain* m_domain;

    mixin accessors;
}