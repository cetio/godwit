module vm.mngstdinterfaces;

import inc.sbuffer;

public struct MngStdInterfacesInfo
{
public:
    SString* friendlyName;

    SString* getFriendlyName()
    {
        return friendlyName;
    }

    void setFriendlyName(SString* newFriendlyName)
    {
        friendlyName = newFriendlyName;
    }
}