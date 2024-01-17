module godwit.backend.bspace;

import godwit.backend.peimage;
import godwit.backend.assemblyname;
import godwit.backend.assemblybinder;
import godwit.backend.domainassembly;
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