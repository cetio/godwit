module godwit.assemblyname;

import godwit.assemblyidentity;
import godwit.llv.traits;

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