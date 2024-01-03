module godwit.mngstdinterfaces;

import godwit.sbuffer;
import godwit.state;

public struct MngStdInterfacesInfo
{
public:
    SString* m_friendlyName;

    mixin accessors;
}