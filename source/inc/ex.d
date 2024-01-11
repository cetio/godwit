module godwit.ex;

import godwit.llv.traits;

public struct EXException
{
public:
    EXException* m_innerException;

    mixin accessors;
}