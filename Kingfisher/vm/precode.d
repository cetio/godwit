module vm.precode;

import state;

public struct Precode
{
public:
    byte[size_t.sizeof * 2] m_data;

    mixin accessors;
}