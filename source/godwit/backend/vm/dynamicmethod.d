module godwit.backend.dynamicmethod;

import godwit.backend.crst;
import godwit.backend.methodtable;
import godwit.backend.ceeload;
import godwit.backend.appdomain;
import godwit.backend.method;
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