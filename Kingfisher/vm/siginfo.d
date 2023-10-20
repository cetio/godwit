module vm.siginfo;

import inc.corhdr;
import vm.typectxt;
import vm.ceeload;

public struct Signature
{
public:
    PCCOR_SIGNATURE sig;
    uint len;
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
}