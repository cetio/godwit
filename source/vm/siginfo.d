module godwit.siginfo;

import godwit.corhdr;
import godwit.typectxt;
import godwit.ceeload;
import godwit.llv.traits;

public struct Signature
{
public:
final:
    PCCOR_SIGNATURE m_sig;
    uint m_len;

    mixin accessors;
}

public struct MetaSig
{
public:
final:
    @flags enum Flags : ubyte
    {
        SigRetTypeInited = 0x01,
        // used to treat some sigs as special case vararg
        // used by calli to unmanaged target
        TreatAsVArg = 0x02,     
    }

    Module* m_ceemodule;
    // Instantiation for type parameters
    SigTypeContext m_typeContext;
    PCCOR_SIGNATURE m_start;
    PCCOR_SIGNATURE m_walk;
    PCCOR_SIGNATURE m_lastType;
    PCCOR_SIGNATURE m_retType;
    uint m_numArgs;
    uint m_curArg;
    CorElementType m_corRetType;
    Flags m_flags;
    ubyte m_callingConv;

    mixin accessors;
}