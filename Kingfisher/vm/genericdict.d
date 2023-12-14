module vm.genericdict;

import vm.typehandle;
import vm.method;
import vm.field;
import inc.corhdr;

alias PerInstInfo = Dictionary;

public struct Dictionary
{
public:
    PCCOR_SIGNATURE[] entries;

    PCCOR_SIGNATURE[] getEntries()
    {
        return entries.dup;
    }

    void setEntries(PCCOR_SIGNATURE[] newEntries)
    {
        entries = newEntries.dup;
    }
}