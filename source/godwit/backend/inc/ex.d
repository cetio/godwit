module godwit.backend.ex;

import caiman.traits;

public struct EXException
{
public:
final:
    EXException* m_innerException;

    mixin accessors;
}