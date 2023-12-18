module vm.typedesc;

import std.bitmanip;
import vm.typehandle;
import inc.corhdr;
import vm.ceeload;
import state;

public struct TypeDesc
{
public:
    @flags enum TypeFlags
    {
        Unrestored = 0x00000400,
        UnrestoredTypeKey = 0x00000800,
        IsNotFullyLoaded = 0x00001000,
        DependenciesLoaded = 0x00002000,
        HasTypeEquivalence = 0x00004000
    }

    mixin(bitfields!(
        CorElementType, "m_elemType", 8,
        TypeFlags, "m_typeFlags", 24
    ));

    mixin accessors;
}

public struct ParamTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    TypeHandle m_arg;
    ptrdiff_t m_exposedClassObject;

    mixin accessors;
}

public struct TypeVarTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    Module* m_ceemodule;
    MDToken m_mdToken;
    uint m_numConstraints;
    TypeHandle* m_constraints;
    ptrdiff_t m_exposedClassObject;
    MDToken m_argMDToken;
    uint m_index;

    mixin accessors;
}

public struct FnPtrTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    uint m_numArgs;
    uint m_callingConv;
    TypeHandle[] m_types;

    mixin accessors;
}