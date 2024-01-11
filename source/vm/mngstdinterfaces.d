module godwit.mngstdinterfaces;

import godwit.sbuffer;
import godwit.llv.traits;

public struct MngStdInterfacesInfo
{
public:
    SString* m_friendlyName;

    mixin accessors;
}