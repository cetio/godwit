module godwit.backend.binder.bspace;

import godwit.backend.vm.peimage;
import godwit.backend.binder.assemblyname;
import godwit.backend.vm.assemblybinder;
import godwit.backend.vm.domainassembly;

public struct BinderSpace
{
public:
final:
    int refCount;
    PEImage* peImage;
    AssemblyName* assemblyName;
    AssemblyBinder* binder;
    bool inTPA;
    DomainAssembly* domainAssembly;

}