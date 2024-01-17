module godwit.exstatecommon;

import caiman.traits;
import godwit.method;
import godwit.impl;

public @flags enum ExceptionFlags
{
    IsRethrown = 0x00000001,
    UnwindingToFindResumeFrame = 0x00000002,
    UnwindHasStarted = 0x00000004,
    // Use this ExInfo to unwind a fault (AV, zerodiv) back to managed code?
    UseExInfoForStackwalk = 0x00000008,        

    SentDebugUserFirstChance = 0x00000010,
    SentDebugFirstChance = 0x00000020,
    SentDebugUnwindBegin = 0x00000040,
    DebugCatchHandlerFound = 0x00000080,
    SentDebugUnhandled = 0x00000100,
    DebuggerInterceptInfo = 0x00000200,
    DebuggerInterceptNotPossible = 0x00000400,
    IsUnhandled = 0x00000800,

    WasThrownByUs = 0x00002000,
    GotWatsonBucketInfo = 0x00004000,
    RPInvokeEscapingException = 0x40000000,
    FlagsAreReadOnly = 0x80000000
}

public enum CorPrfClauseType
{
    None = 0,
    Filter = 1,
    Catch = 2,
    Finally = 3,
} 

public struct EHClauseInfo
{
public:
final:
    uint* m_ip;
    uint* m_sf;
    /// Caller stack frame
    uint* m_csf;
    CorPrfClauseType m_ClauseType;
    /// Indicates that this clause takes place in managed code
    bool m_managed;

    mixin accessors;
}

public struct DebuggerExState
{
public:
final:
    // This frame pointer marks the latest stack frame examined by the EH subsystem in the first pass.
    // An exception cannot be intercepted closer to the root than this frame pointer.
    uint* m_debuggerIndicatedFramePointer;
    MethodDesc* m_debuggerInterceptedFn;
    /// The frame pointer of the stack frame where we are intercepting the exception
    uint* m_debuggerInterceptFramePointer;
    void* m_debuggerContext;
    /// The native offset at which to resume execution
    uint* m_debuggerInterceptNativeOffset;
    static if (!EH_FUNCLETS)
    {
        uint* m_debuggerInterceptFrame;
    }
    // The nesting level at which we want to resume execution
    int m_debuggerInterceptHandlerDepth;

    mixin accessors;
}

public struct EHWatsonBucketTracker
{
public:
final:
    @flags enum DebugFlags : uint
    {
        // Bucket details were captured for ThreadAbort
        CapturedForThreadAbort = 1,
        // Bucket details were captured at AD Transition
        CapturedAtADTransition = 2,
        // Bucket details were captured during Reflection invocation
        CapturedAtReflectionInvocation = 4
    }

    void* m_unhandledBuckets;
    uint* m_unhandledIp;
    static if (DEBUG)
    {
        DebugFlags m_debugFlags;
    }

    mixin accessors;
}