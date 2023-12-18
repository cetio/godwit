module godwit.ex;

import godwit.state;

public struct EXException
{
public:
    EXException* m_innerException;

    mixin accessors;
}