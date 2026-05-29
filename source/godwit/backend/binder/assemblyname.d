module godwit.backend.binder.assemblyname;

import godwit.backend.binder.assemblyidentity;

public struct AssemblyName
{
    AssemblyIdentity assemblyIdentity;
    alias assemblyIdentity this;

public:
final:
    int refCount;
    bool isDefinition;

}