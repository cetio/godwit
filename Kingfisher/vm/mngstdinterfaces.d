module vm.mngstdinterfaces;

import inc.sbuffer;
import state;

public struct MngStdInterfacesInfo
{
public:
    SString* m_friendlyName;

    mixin accessors;
}