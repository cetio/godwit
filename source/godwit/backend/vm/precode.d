/// Represents precode/prologue data for methods
module godwit.backend.vm.precode;

import caiman.traits;

/// Method prologue data structure, effectively just a byte array
public struct Precode
{
public:
final:
    /// Method prologue data, may be null, 
    /// depending on if the method was initialized with precode or not
    byte[size_t.sizeof * 2] m_data;

    mixin accessors;
}