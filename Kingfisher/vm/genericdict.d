module vm.genericdict;

import vm.typehandle;
import vm.method;
import vm.field;
import inc.corhdr;
import state;

alias PerInstInfo = Dictionary;

public struct Dictionary
{
public:
    PCCOR_SIGNATURE[] m_entries;

    mixin accessors;
}