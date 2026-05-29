module godwit.backend.siginfo;

import godwit.backend.inc.corhdr;
import godwit.backend.vm.typectxt;
import godwit.backend.vm.ceeload;

public struct Signature
{
public:
final:
    PCCOR_SIGNATURE sig;
    uint len;

}

public struct MetaSig
{
public:
final:
    enum Flags : ubyte
    {
        SigRetTypeInited = 0x01,
        /// Used to treat some sigs as special case vararg \
        /// Used by calli to unmanaged target
        TreatAsVArg = 0x02,
    }

    Module* ceemodule;
    /// Instantiation for type parameters
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