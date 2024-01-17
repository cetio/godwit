/**
    Definitions for "dictionaries" used to encapsulate generic instantiations
    and instantiation-specific information for shared-code generics
*/
module godwit.backend.genericdict;

import godwit.backend.typehandle;
import godwit.backend.method;
import godwit.backend.field;
import godwit.backend.corhdr;
import caiman.traits;

/// Generic dictionary, for instantiated types and methods (TBD) \
/// This is just an abstraction around an open-ended array
public struct Dictionary
{
public:
final:
    /// Signatures of all instantiations
    PCCOR_SIGNATURE[] m_entries;

    mixin accessors;
}