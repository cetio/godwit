module godwit.assemblyname;

import godwit.assemblyidentity;
import godwit.mem.state;

public struct AssemblyName
{
    AssemblyIdentity assemblyIdentity;
    alias assemblyIdentity this;

public:
    int m_refCount;
    bool m_isDefinition;

    mixin accessors;
}