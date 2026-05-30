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
    size_t ip;
    size_t sf;
    size_t csf;
    CorPrfClauseType clauseType;
    bool managed;

}

public struct DebuggerExState
{
public:
final:
    size_t debuggerIndicatedFramePointer;
    MethodDesc* debuggerInterceptedFn;
    size_t debuggerInterceptFramePointer;
    void* debuggerContext;
    size_t debuggerInterceptNativeOffset;
    static if (!EH_FUNCLETS)
    {
        void* debuggerInterceptFrame;
    }
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
    size_t unhandledIp;
    static if (DEBUG)
    {
        DebugFlags debugFlags;
    }

}