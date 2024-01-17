module godwit.dynamicmethod;

import godwit.crst;
import godwit.methodtable;
import godwit.ceeload;
import godwit.appdomain;
import godwit.method;
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