module godwit.mngstdinterfaces;

import godwit.sbuffer;
import caiman.traits;

public struct MngStdInterfacesInfo
{
public:
final:
    SString* m_friendlyName;

    mixin accessors;
}