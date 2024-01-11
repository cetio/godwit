/**
Definitions for "dictionaries" used to encapsulate generic instantiations
and instantiation-specific information for shared-code generics
*/
module godwit.genericdict;

import godwit.typehandle;
import godwit.method;
import godwit.field;
import godwit.corhdr;
import godwit.llv.traits;

alias PerInstInfo = Dictionary;

/// Generic dictionary, for instantiated types and methods (TBD)
///
/// This is just an abstraction around an open-ended array
public struct Dictionary
{
public:
    /// Signatures of all instantiations
    PCCOR_SIGNATURE[] m_entries;

    mixin accessors;
}