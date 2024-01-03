module godwit.genericdict;

import godwit.typehandle;
import godwit.method;
import godwit.field;
import godwit.corhdr;
import godwit.state;

alias PerInstInfo = Dictionary;

public struct Dictionary
{
public:
    PCCOR_SIGNATURE[] m_entries;

    mixin accessors;
}