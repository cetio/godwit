module godwit.backend.binder.bspace;

import godwit.backend.vm.peimage;
import godwit.backend.binder.assemblyname;
import godwit.backend.vm.assemblybinder;
import godwit.backend.vm.domainassembly;
import caiman.traits;

public struct BinderSpace
{
public:
final:
    int m_refCount;
    PEImage* m_peImage;
    AssemblyName* m_assemblyName;
    AssemblyBinder* m_binder;
    bool m_inTPA;
    DomainAssembly* m_domainAssembly;

    mixin accessors;
}