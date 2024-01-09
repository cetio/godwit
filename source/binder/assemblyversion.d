module godwit.assemblyversion;

import godwit.collections.state;

public struct AssemblyVersion
{
public:
    uint m_major;
    uint m_minor;
    uint m_build;
    uint m_revision;

    mixin accessors;
}