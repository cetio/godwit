module godwit.assemblyversion;

import godwit.llv.traits;

public struct AssemblyVersion
{
public:
final:
    uint m_major;
    uint m_minor;
    uint m_build;
    uint m_revision;

    mixin accessors;
}