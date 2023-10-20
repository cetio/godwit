module binder.assemblyname;

import binder.assemblyidentity;

public struct AssemblyName
{
    AssemblyIdentity assemblyIdentity;
    alias assemblyIdentity this;

public:
    int refCount;
    bool isDefinition;
}