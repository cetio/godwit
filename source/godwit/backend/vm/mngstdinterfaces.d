module godwit.backend.mngstdinterfaces;

import godwit.backend.sbuffer;
import caiman.traits;

public struct MngStdInterfacesInfo
{
public:
final:
    SString* m_friendlyName;

    mixin accessors;
}