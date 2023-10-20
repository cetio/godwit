module vm.exinfo;

import vm.objects;
import inc.pal;
import vm.clrex;
import vm.objects;

public struct ExInfo
{
public:
    // Note: the debugger assumes that m_pThrowable is a strong
    // reference so it can check it for NULL with preemptive GC
    // enabled.
    // thrown exception
    ObjectHandle hndThrowable;
    // topmost frame for current managed frame group
    ushort** searchBoundary;
    // After a catch of a COM+ exception, pointers/context are trashed.
    uint exceptionCode;
    // most recent EH record registered
    void* bottomMostHandler;
    // Reference to the topmost handler we saw during an SO that goes past us
    void* topMostHandlerDuringSO;
    // Esp when  fault occurred, OR esp to restore on endcatch
    void* esp;
    StackTraceInfo stackTraceInfo;
    // pointer to nested info if are handling nested exception
    ExInfo* prevNestedInfo;
    // Zero this after endcatch
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
    /*
#ifndef TARGET_UNIX
    EHWatsonBucketTracker m_WatsonBucketTracker;
#endif
    */
    bool deliveredFirstChanceNotification;
}