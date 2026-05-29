module godwit.backend.vm.exinfo;

import godwit.backend.vm.object;
import godwit.backend.inc.pal;
import godwit.backend.vm.clrex;
import godwit.backend.vm.object;
import godwit.backend.vm.exstatecommon;
import godwit.impl;

public struct EHContext
{
public:
final:
    uint eax;
    uint ebx;
    uint ecx;
    uint edx;
    uint esi;
    uint edi;
    uint ebp;
    uint esp;
    uint eip;

}

public struct ExInfo
{
public:
final:
    ObjectHandle hndThrowable;
    /// Topmost frame for current managed frame group
    ushort** searchBoundary;
    /// After a catch of a COM+ exception, pointers/context are trashed.
    uint exceptionCode;
    /// Most recent EH record registered
    void* bottomMostHandler;
    /// Reference to the topmost handler we saw during an SO that goes past us
    void* topMostHandlerDuringSO;
    /// Esp when fault occurred, OR esp to restore on endcatch
    void* esp;
    StackTraceInfo stackTraceInfo;
    /// Pointer to nested info if are handling nested exception
    ExInfo* prevNestedInfo;
    /// Zero this after endcatch
    size_t* shadowSP;
    ExceptionRecord* exceptionRecord;
    ExceptionPointers* exceptionPointers;
    int* context;
    // We have a rare case where (re-entry to the EE from an unmanaged filter) where we
    // need to create a new ExInfo ... but don't have a nested handler for it.  The handlers
    // use stack addresses to figure out their correct lifetimes.  This stack location is
    // used for that.  For most records, it will be the stack address of the ExInfo ... but
    // for some records, it will be a pseudo stack location -- the place where we think
    // the record should have been (except for the re-entry case).
    void* stackAddress;
    version (Windows)
    {
        EHWatsonBucketTracker WatsonBucketTracker;
    }
    bool deliveredFirstChanceNotification;
    DebuggerExState debuggerExState;
    EHClauseInfo ehClauseInfo;
    ExceptionFlags exceptionFlags;
    version (X86)
    {
        static if (DEBUGGING_SUPPORTED)
        {
            EHContext interceptionContext;
            bool validInterceptionContext;
        }
    }

}