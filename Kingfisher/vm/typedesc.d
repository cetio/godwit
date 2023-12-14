module vm.typedesc;

import std.bitmanip;
import vm.typehandle;
import inc.corhdr;
import vm.ceeload;
import flags;

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

    bool isUnrestored()
    {
        return typeFlags.hasFlag(TypeFlags.Unrestored);
    }

    bool isUnrestoredTypeKey()
    {
        return typeFlags.hasFlag(TypeFlags.UnrestoredTypeKey);
    }

    bool isIsNotFullyLoaded()
    {
        return typeFlags.hasFlag(TypeFlags.IsNotFullyLoaded);
    }

    bool isDependenciesLoaded()
    {
        return typeFlags.hasFlag(TypeFlags.DependenciesLoaded);
    }

    bool isHasTypeEquivalence()
    {
        return typeFlags.hasFlag(TypeFlags.HasTypeEquivalence);
    }

    void setElemType(CorElementType newElemType)
    {
        elemType = newElemType;
    }

    void setTypeFlags(TypeFlags newTypeFlags)
    {
        typeFlags = newTypeFlags;
    }

    void setIsUnrestored(bool state)
    {
        typeFlags.setFlag(TypeFlags.Unrestored, state);
    }

    void setIsUnrestoredTypeKey(bool state)
    {
        typeFlags.setFlag(TypeFlags.UnrestoredTypeKey, state);
    }

    void setIsNotFullyLoaded(bool state)
    {
        typeFlags.setFlag(TypeFlags.IsNotFullyLoaded, state);
    }

    void setIsDependenciesLoaded(bool state)
    {
        typeFlags.setFlag(TypeFlags.DependenciesLoaded, state);
    }

    void setIsHasTypeEquivalence(bool state)
    {
        typeFlags.setFlag(TypeFlags.HasTypeEquivalence, state);
    }
}

public struct ParamTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    TypeHandle arg;
    ptrdiff_t exposedClassObject;

    TypeHandle getArg()
    {
        return arg;
    }

    void setArg(TypeHandle newArg)
    {
        arg = newArg;
    }

    ptrdiff_t getExposedClassObject()
    {
        return exposedClassObject;
    }

    void setExposedClassObject(ptrdiff_t newExposedClassObject)
    {
        exposedClassObject = newExposedClassObject;
    }
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

    Module* getModule()
    {
        return ceemodule;
    }

    void setModule(Module* newModule)
    {
        ceemodule = newModule;
    }

    MDToken getMdToken()
    {
        return mdToken;
    }

    void setMdToken(MDToken newMdToken)
    {
        mdToken = newMdToken;
    }

    uint getNumConstraints()
    {
        return numConstraints;
    }

    void setNumConstraints(uint newNumConstraints)
    {
        numConstraints = newNumConstraints;
    }

    TypeHandle* getConstraints()
    {
        return constraints;
    }

    void setConstraints(TypeHandle* newConstraints)
    {
        constraints = newConstraints;
    }

    ptrdiff_t getExposedClassObject()
    {
        return exposedClassObject;
    }

    void setExposedClassObject(ptrdiff_t newExposedClassObject)
    {
        exposedClassObject = newExposedClassObject;
    }

    MDToken getArgMDToken()
    {
        return argMDToken;
    }

    void setArgMDToken(MDToken newArgMDToken)
    {
        argMDToken = newArgMDToken;
    }

    uint getIndex()
    {
        return index;
    }

    void setIndex(uint newIndex)
    {
        index = newIndex;
    }

}

public struct FnPtrTypeDesc
{
    TypeDesc typeDesc;
    alias typeDesc this;

public:
    uint numArgs;
    uint callingConv;
    TypeHandle[] types;

    uint getNumArgs()
    {
        return numArgs;
    }

    void setNumArgs(uint newNumArgs)
    {
        numArgs = newNumArgs;
    }

    uint getCallingConv()
    {
        return callingConv;
    }

    void setCallingConv(uint newCallingConv)
    {
        callingConv = newCallingConv;
    }

    TypeHandle[] getTypes()
    {
        return types;
    }

    void setTypes(TypeHandle[] newTypes)
    {
        types = newTypes.dup;
    }
}