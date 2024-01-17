module godwit.backend.siginfo;

import godwit.backend.corhdr;
import godwit.backend.typectxt;
import godwit.backend.ceeload;
import caiman.traits;

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
        /// Used to treat some sigs as special case vararg \
        /// Used by calli to unmanaged target
        TreatAsVArg = 0x02,     
    }

    Module* m_ceemodule;
    /// Instantiation for type parameters
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