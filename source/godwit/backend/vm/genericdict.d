/**
    Definitions for "dictionaries" used to encapsulate generic instantiations
    and instantiation-specific information for shared-code generics
*/
module godwit.backend.vm.genericdict;

import godwit.backend.vm.typehandle;
import godwit.backend.vm.method;
import godwit.backend.vm.field;
import godwit.backend.inc.corhdr;
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