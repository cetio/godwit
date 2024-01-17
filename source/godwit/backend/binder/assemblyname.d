module godwit.backend.assemblyname;

import godwit.backend.assemblyidentity;
import caiman.traits;

public struct AssemblyName
{
    AssemblyIdentity assemblyIdentity;
    alias assemblyIdentity this;

public:
final:
    int m_refCount;
    bool m_isDefinition;

    mixin accessors;
}