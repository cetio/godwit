module vm.typedesc;

import std.bitmanip;
import vm.typehandle;
import inc.corhdr;
import vm.ceeload;

public struct TypeDesc
{
public:
    enum TypeFlags
    {
        Unrestored = 0x00000400,
        UnrestoredTypeKey = 0x00000800,
        IsNotFullyLoaded = 0x00001000,
        DependenciesLoaded = 0x00002000,
        HasTypeEquivalence = 0x00004000
    };

    mixin(bitfields!(
        CorElementType, "elemType", 8,
        TypeFlags, "typeFlags", 24
    ));

    CorElementType getElemType()
    {
        return elemType;
    }

    TypeFlags getTypeFlags()
    {
        return typeFlags;
    }
}

public struct ParamTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    TypeHandle arg;
    ptrdiff_t exposedClassObject;
}

public struct TypeVarTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    Module* ceemodule;
    MDToken mdToken;
    uint numConstraints;
    TypeHandle* constraints;
    ptrdiff_t exposedClassObject;
    MDToken argMDToken;
    uint index;
}

public struct FnPtrTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    uint numArgs;
    uint callingConv;
    TypeHandle[] types;
}