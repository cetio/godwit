module binder.assembly;

import vm.peimage;
import binder.assemblyname;
import vm.assemblybinder;
import vm.domainassembly;

public struct BinderSpace
{
public:
    int refCount;
    PEImage* peImage;
    AssemblyName* assemblyName;
    AssemblyBinder* binder;
    bool inTPA;
    DomainAssembly* domainAssembly;
}