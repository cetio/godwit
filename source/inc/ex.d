module godwit.ex;

import godwit.mem.state;

public struct EXException
{
public:
    EXException* m_innerException;

    mixin accessors;
}