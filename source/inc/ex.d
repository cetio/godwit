module godwit.ex;

import godwit.llv.traits;

public struct EXException
{
public:
final:
    EXException* m_innerException;

    mixin accessors;
}