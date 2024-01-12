module godwit.typedesc;

import std.bitmanip;
import godwit.typehandle;
import godwit.corhdr;
import godwit.ceeload;
import godwit.llv.traits;

/**
   TypeDesc is a discriminated union of all types that can not be directly
   represented by a simple MethodTable*.   The discrimintor of the union at the present
   time is the CorElementType numeration.  The subclass of TypeDesc are
   the possible variants of the union.


   ParamTypeDescs only include byref, array and pointer types.  They do NOT
   include instantiations of generic types, which are represented by MethodTables.
*/
public struct TypeDesc
{
public:
final:
    @flags enum TypeFlags
    {
        Unrestored = 0x00000400,
        UnrestoredTypeKey = 0x00000800,
        IsNotFullyLoaded = 0x00001000,
        DependenciesLoaded = 0x00002000,
        HasTypeEquivalence = 0x00004000
    }

    // For whatever reason, we can't generate accessors for typeFlags
    mixin(bitfields!(
        CorElementType, "m_elemType", 8,
    // TODO: This todo exists to mark that this is intentionally not part of the accessor gen.
        uint, "typeFlags", 24
    ));

    mixin accessors;
}

/** 
    This variant is used for parameterized types that have exactly one argument type. 
 
    This includes arrays, byrefs, pointers.
 */
public struct ParamTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
final:
    TypeHandle m_arg;
    ptrdiff_t m_exposedClassObject;

    mixin accessors;
}

/** 
 * These are for verification of generic code and reflection over generic code.
 * 
 * Each TypeVarTypeDesc represents a class or method type variable, as specified by a GenericParam entry.
 * 
 * The type variables are tied back to the class or method that *defines* them.
 * This is done through typedef or methoddef tokens.
 */
public struct TypeVarTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
final:
    Module* m_ceemodule;
    MDToken m_mdToken;
    uint m_numConstraints;
    TypeHandle* m_constraints;
    ptrdiff_t m_exposedClassObject;
    MDToken m_argMDToken;
    uint m_index;

    mixin accessors;
}

/** 
 * Represents a function pointer type, such as a delegate
 */
public struct FnPtrTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
final:
    /// Number of arguments
    uint m_numArgs;
    /// Calling convention
    uint m_callingConv;
    /// Types of the function pointer
    TypeHandle[] m_types; 

    mixin accessors;
}