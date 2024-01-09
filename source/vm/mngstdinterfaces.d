module godwit.mngstdinterfaces;

import godwit.sbuffer;
import godwit.mem.state;

public struct MngStdInterfacesInfo
{
public:
    SString* m_friendlyName;

    mixin accessors;
}