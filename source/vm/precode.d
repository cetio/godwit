/// Represents precode/prologue data for methods
module godwit.precode;

import godwit.collections.state;

/// Method prologue data structure, effectively just a byte array
public struct Precode
{
public:
    /// Method prologue data, may be null, 
    /// depending on if the method was initialized with precode or not
    byte[size_t.sizeof * 2] m_data;

    mixin accessors;
}