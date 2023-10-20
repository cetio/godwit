module vm.crst;

public struct CrstBase
{
public:
    enum ReservedFlags : uint
    {
        CRST_RESERVED_FLAGS_MASK = 0xC0000000,
        CRST_INITIALIZED = 0x80000000,
        CRST_OS_CRIT_SEC = 0x40000000,
    }

    // ReservedFlags only represents the base required flags,
    // This can contain more than ReservedFlags.
    ReservedFlags flags;
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

    ReservedFlags getFlags()
    {
        return flags;
    }
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