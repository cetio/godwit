module godwit.crst;

import godwit.mem.state;

public struct CrstBase
{
public:
    @flags enum ReservedFlags : uint
    {
        ReservedFlagsMask = 0xC0000000,
        kInitialized = 0x80000000,
        kOSCritSec = 0x40000000,
    }

    // ReservedFlags only represents the base required flags,
    // This can contain more than ReservedFlags.
    ReservedFlags m_flags;
    /*
#ifdef _DEBUG
    UINT                m_entercount;       // # of unmatched Enters.
    CrstType            m_crstType;         // Type enum (should have a descriptive name for debugging)
    const char         *m_tag;              // Stringized form of the tag for easy debugging
    int                 m_crstlevel;        // what level is the crst in?
    EEThreadId          m_holderthreadid;   // current holder (or NULL)
    CrstBase           *m_next;             // link for global linked list
    CrstBase           *m_prev;             // link for global linked list
    Volatile<LONG>      m_cannotLeave;

    // Check for dead lock situation.
    ULONG               m_countNoTriggerGC;

    void                PostEnter ();
    void                PreEnter ();
    void                PreLeave  ();
#endif //_DEBUG
    */
    mixin accessors;
}

public struct Crst
{
    CrstBase crstBase;
    alias crstBase this;
}

public struct CrstStatic
{
    CrstBase crstBase;
    alias crstBase this;
}

public struct CrstExplicitInit
{
    CrstStatic crstStatic;
    alias crstStatic this;
}