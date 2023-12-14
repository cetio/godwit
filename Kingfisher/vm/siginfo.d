module vm.siginfo;

import inc.corhdr;
import vm.typectxt;
import vm.ceeload;
import flags;

public struct Signature
{
public:
    PCCOR_SIGNATURE sig;
    uint len;

    PCCOR_SIGNATURE getSig()
    {
        return sig;
    }

    uint getLen()
    {
        return len;
    }
}

public struct MetaSig
{
public:
    enum Flags : ubyte
    {
        SigRetTypeInited = 0x01,
        // used to treat some sigs as special case vararg
        // used by calli to unmanaged target
        TreatAsVArg = 0x02,     
    };

    Module* ceemodule;
    // Instantiation for type parameters
    SigTypeContext typeContext;
    PCCOR_SIGNATURE start;
    PCCOR_SIGNATURE walk;
    PCCOR_SIGNATURE lastType;
    PCCOR_SIGNATURE retType;
    uint numArgs;
    uint curArg;
    CorElementType corRetType;
    Flags flags;
    ubyte callingConv;

    Module* getModule()
    {
        return ceemodule;
    }

    SigTypeContext getTypeContext()
    {
        return typeContext;
    }

    PCCOR_SIGNATURE getStart()
    {
        return start;
    }

    PCCOR_SIGNATURE getWalk()
    {
        return walk;
    }

    PCCOR_SIGNATURE getLastType()
    {
        return lastType;
    }

    PCCOR_SIGNATURE getRetType()
    {
        return retType;
    }

    uint getNumArgs()
    {
        return numArgs;
    }

    uint getCurArg()
    {
        return curArg;
    }

    CorElementType getCorRetType()
    {
        return corRetType;
    }

    Flags getFlags()
    {
        return flags;
    }

    bool isSigRetTypeInited()
    {
        return flags.hasFlag(Flags.SigRetTypeInited);
    }

    bool isTreatAsVArg()
    {
        return flags.hasFlag(Flags.TreatAsVArg);
    }

    ubyte getCallingConv()
    {
        return callingConv;
    }

    void setModule(Module* newModule)
    {
        ceemodule = newModule;
    }

    void setTypeContext(SigTypeContext newTypeContext)
    {
        typeContext = newTypeContext;
    }

    void setStart(PCCOR_SIGNATURE newStart)
    {
        start = newStart;
    }

    void setWalk(PCCOR_SIGNATURE newWalk)
    {
        walk = newWalk;
    }

    void setLastType(PCCOR_SIGNATURE newLastType)
    {
        lastType = newLastType;
    }

    void setRetType(PCCOR_SIGNATURE newRetType)
    {
        retType = newRetType;
    }

    void setNumArgs(uint newNumArgs)
    {
        numArgs = newNumArgs;
    }

    void setCurArg(uint newCurArg)
    {
        curArg = newCurArg;
    }

    void setCorRetType(CorElementType newCorRetType)
    {
        corRetType = newCorRetType;
    }

    void setFlags(Flags newFlags)
    {
        flags = newFlags;
    }

    void setIsSigRetTypeInited(bool state)
    {
        flags.setFlag(Flags.SigRetTypeInited, state);
    }

    void setIsTreatAsVArg(bool state)
    {
        flags.setFlag(Flags.TreatAsVArg, state);
    }

    void setCallingConv(ubyte newCallingConv)
    {
        callingConv = newCallingConv;
    }
}