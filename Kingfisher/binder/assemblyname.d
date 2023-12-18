module binder.assemblyname;

import binder.assemblyidentity;
import state;

public struct AssemblyName
{
    AssemblyIdentity assemblyIdentity;
    alias assemblyIdentity this;

public:
    int m_refCount;
    bool m_isDefinition;

    mixin accessors;
}