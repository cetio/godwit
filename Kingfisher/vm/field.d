module vm.field;

import std.bitmanip;
import inc.corhdr;

// Equivalent to System.Runtime.FieldInfo.
public struct FieldDesc
{
public:
    enum Protection
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
        uint, "mb", 26,
        // Is this field static?
        bool, "isfStatic", 1, 
        // Is this field thread local?
        // Has a separate instance for each thread, allowing each thread to have its own independent copy of the variable's data.
        bool, "isfThreadLocal", 1,
        // Does this field use a RVA (relative value address) to store its data?
        // If so, this requires extra parsing in the PE to get the address of this field's data.
        bool, "isfRVA", 1,
        // Protection level of this field.
        Protection, "protection", 3
    ));
    mixin(bitfields!(
        // Offset of this field in memory (assuming that you have a pointer to an instance of its containing type.)
        // This will lie to you if this field is static/RVA.
        uint, "offset", 27,
        // CorElementType of this field.
        // This will not directly give you the type of this field.
        CorElementType, "elemType", 5
    ));

    uint getMB()
    {
        return mb;
    }

    bool isStatic()
    {
        return isfStatic;
    }

    bool isThreadLocal()
    {
        return isfThreadLocal;
    }

    bool isRVA()
    {
        return isfRVA;
    }

    bool isPrivate()
    {
        return (protection & Protection.Private) == 0 ||
            (protection & Protection.PrivateProtected) == 0;
    }

    bool isInternal()
    {
        return (protection & Protection.Internal) == 0;
    }

    bool isProtected()
    {
        return (protection & Protection.Protected) == 0 ||
            (protection & Protection.ProtectedInternal) == 0;
    }

    bool isPublic()
    {
        return (protection & Protection.Public) == 0;
    }

    uint getOffset()
    {
        return offset;
    }

    CorElementType getElemType()
    {
        return elemType;
    }
}