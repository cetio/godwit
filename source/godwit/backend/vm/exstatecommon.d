module godwit.backend.vm.exstatecommon;

import godwit.backend.vm.method;
import godwit.impl;

public enum ExceptionFlags
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
    uint* ip;
    uint* sf;
    /// Caller stack frame
    uint* csf;
    CorPrfClauseType ClauseType;
    /// Indicates that this clause takes place in managed code
    bool managed;

}

public struct DebuggerExState
{
public:
final:
    // This frame pointer marks the latest stack frame examined by the EH subsystem in the first pass.
    // An exception cannot be intercepted closer to the root than this frame pointer.
    uint* debuggerIndicatedFramePointer;
    MethodDesc* debuggerInterceptedFn;
    /// The frame pointer of the stack frame where we are intercepting the exception
    uint* debuggerInterceptFramePointer;
    void* debuggerContext;
    /// The native offset at which to resume execution
    uint* debuggerInterceptNativeOffset;
    static if (!EH_FUNCLETS)
    {
        uint* debuggerInterceptFrame;
    }
    // The nesting level at which we want to resume execution
    int debuggerInterceptHandlerDepth;

}

public struct EHWatsonBucketTracker
{
public:
final:
    enum DebugFlags : uint
    {
        // Bucket details were captured for ThreadAbort
        CapturedForThreadAbort = 1,
        // Bucket details were captured at AD Transition
        CapturedAtADTransition = 2,
        // Bucket details were captured during Reflection invocation
        CapturedAtReflectionInvocation = 4
    }

    void* unhandledBuckets;
    uint* unhandledIp;
    static if (DEBUG)
    {
        DebugFlags debugFlags;
    }

}