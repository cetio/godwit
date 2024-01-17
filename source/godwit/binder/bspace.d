module godwit.bspace;

import godwit.peimage;
import godwit.assemblyname;
import godwit.assemblybinder;
import godwit.domainassembly;
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