module godwit.backend.vm.field;

import std.bitmanip;
import godwit.backend.inc.corhdr;
import caiman.traits;

/// Field descriptor, equivalent to `System.Runtime.FieldInfo` \
/// Field descriptors for fields in instantiated types may be shared between compatible instantiations
public struct FieldDesc
{
public:
final:
    @flags enum Protection
    {
        Unknown = 0,
        Private = 1,
        PrivateProtected = 2,
        Internal = 3,
        Protected = 4,
        ProtectedInternal = 5,
        Public = 6
    }

    mixin(bitfields!(
        // I have no clue what this means.
        uint, "m_mb", 26,
        /// Is this field static?
        bool, "m_isfStatic", 1, 
        /// Is this field thread local?
        /// Has a separate instance for each thread, allowing each thread to have its own independent copy of the variable's data.
        bool, "m_isfThreadLocal", 1,
        /// Does this field use a RVA (relative value address) to store its data?
        /// If so, this requires extra parsing in the PE to get the address of this field's data.
        bool, "m_isfRVA", 1,
        /// Protection level of this field.
        Protection, "m_protection", 3
    ));
    mixin(bitfields!(
        /// Offset of this field in memory (assuming that you have a pointer to an instance of its containing type.)
        /// This will lie to you if this field is static/RVA.
        uint, "m_offset", 27,
        /// CorElementType of this field.
        /// This will not directly give you the type of this field.
        CorElementType, "m_elemType", 5
    ));

    mixin accessors;

    /*ubyte* getAddress(ubyte* ptr)
    {
        return ptr + offset;
    }*/
}