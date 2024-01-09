module godwit.ex;

import godwit.collections.state;

public struct EXException
{
public:
    EXException* m_innerException;

    mixin accessors;
}