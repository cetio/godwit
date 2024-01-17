module godwit.exinfo;

import godwit.objects;
import godwit.pal;
import godwit.clrex;
import godwit.objects;
import caiman.traits;
import godwit.exstatecommon;

public struct EHContext
{
public:
final:
    uint m_eax;
    uint m_ebx;
    uint m_ecx;
    uint m_edx;
    uint m_esi;
    uint m_edi;
    uint m_ebp;
    uint m_esp;
    uint m_eip;

    mixin accessors;
}

public struct ExInfo
{
public:
final:
    ObjectHandle m_hndThrowable;
    /// Topmost frame for current managed frame group
    ushort** m_searchBoundary;
    /// After a catch of a COM+ exception, pointers/context are trashed.
    uint m_exceptionCode;
    /// Most recent EH record registered
    void* m_bottomMostHandler;
    /// Reference to the topmost handler we saw during an SO that goes past us
    void* m_topMostHandlerDuringSO;
    /// Esp when fault occurred, OR esp to restore on endcatch
    void* m_esp;
    StackTraceInfo m_stackTraceInfo;
    /// Pointer to nested info if are handling nested exception
    ExInfo* m_prevNestedInfo;
    /// Zero this after endcatch
    size_t* m_shadowSP;
    ExceptionRecord* m_exceptionRecord;
    ExceptionPointers* m_exceptionPointers;
    int* m_context;
    // We have a rare case where (re-entry to the EE from an unmanaged filter) where we
    // need to create a new ExInfo ... but don't have a nested handler for it.  The handlers
    // use stack addresses to figure out their correct lifetimes.  This stack location is
    // used for that.  For most records, it will be the stack address of the ExInfo ... but
    // for some records, it will be a pseudo stack location -- the place where we think
    // the record should have been (except for the re-entry case).
    void* m_stackAddress;
    version (Windows)
    {
        EHWatsonBucketTracker m_WatsonBucketTracker;
    }
    bool m_deliveredFirstChanceNotification;
    DebuggerExState m_debuggerExState;
    EHClauseInfo m_ehClauseInfo;
    ExceptionFlags m_exceptionFlags;
    version (X86)
    {
        static if (DEBUGGING_SUPPORTED)
        {
            EHContext m_interceptionContext;
            bool m_validInterceptionContext;
        }
    }

    mixin accessors;
}