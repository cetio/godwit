module inc.ex;

import state;

public struct EXException
{
public:
    EXException* m_innerException;

    mixin accessors;
}