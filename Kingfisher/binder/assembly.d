module binder.assembly;

import vm.peimage;
import binder.assemblyname;
import vm.assemblybinder;
import vm.domainassembly;
import state;

public struct BinderSpace
{
public:
    int m_refCount;
    PEImage* m_peImage;
    AssemblyName* m_assemblyName;
    AssemblyBinder* m_binder;
    bool m_inTPA;
    DomainAssembly* m_domainAssembly;

    mixin accessors;
}