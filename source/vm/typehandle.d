module godwit.typehandle;

import godwit.methodtable;
import godwit.typedesc;
import godwit.mem.state;

/**
 * A TypeHandle is the FUNDAMENTAL concept of type identity in the CLR.
 * That is two types are equal if and only if their type handles
 * are equal.  A TypeHandle, is a pointer sized struture that encodes
 * everything you need to know to figure out what kind of type you are
 * actually dealing with.

 * At the present time a TypeHandle can point at two possible things
 *
 *      1) A MethodTable    (Arrays, Intrinsics, Classes, Value Types and their instantiations)
 *      2) A TypeDesc       (all other cases = byrefs, pointer types, function pointers, generic type variables)
 *
 * or with IL stubs, a third thing:
 *
 *      3) A MethodTable for a native value type.
 *
 * Wherever possible, you should be using TypeHandles or MethodTables.
 * Code that is known to work over Class/ValueClass types (including their
 * instantaitions) is currently written to use MethodTables.
 *
 * TypeDescs in turn break down into several variants and are
 * for special cases around the edges
 *    - types for function pointers for verification and reflection
 *    - types for generic parameters for verification and reflection
 *
 * Generic type instantiations (in C# syntax = C<ty_1,...,ty_n>) are represented by
 * MethodTables, i.e. a new MethodTable gets allocated for each such instantiation.
 * The entries in these tables (i.e. the code) are, however, often shared.
 * Clients of TypeHandle don't need to know any of this detail; just use the
 * GetInstantiation and HasInstantiation methods.
 */
public struct TypeHandle
{
public:
    // TypeHandle may represent any of the following:
    union
    {
        MethodTable* m_methodTable;
        TypeDesc* m_typeDesc;
        ParamTypeDesc* m_paramTypeDesc;
        TypeVarTypeDesc* m_typeVarTypeDesc;
        FnPtrTypeDesc* m_fnPtrTypeDesc;
    }

    mixin accessors;
}

/**
 * Represents an instantiation of generic types.
 *
 * It is simple read-only array of TypeHandles. In NGen, the type handles
 * may be encoded using indirections. 
 *
 * That's one reason why it is convenient to have wrapper class that performs the decoding.
 */
public struct Instantiation
{
public:
    /// Note that for DAC builds, m_pArgs may be host allocated buffer, not a copy of an object marshalled by DAC.
    /// Pointer to TypeHandles for the instantiation
    TypeHandle* m_args;
    /// Number of arguments in the instantiation
    uint m_numArgs;

    mixin accessors;
}