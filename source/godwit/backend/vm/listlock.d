module godwit.backend.listlock;

import godwit.backend.codeversion;
import godwit.backend.crst;
import godwit.backend.threads;
import godwit.backend.loaderallocator;
import caiman.traits;
import caiman.state;

alias ListLock = ListLockBase!(void*);
alias ListLockEntry = ListLockEntryBase!(void*);
alias JitListLock = ListLockBase!NativeCodeVersion;

public struct ListLockBase(T)
{
public:
final:
    CrstStatic m_crst;
    bool m_isfInit;
    /// Lock can be broken by a host for deadlock detection
    bool m_hostBreakable;
    ListLockEntryBase!T* m_head;

    mixin accessors;
}

public struct ListLockEntryBase(T)
{
public:
final:
    DeadlockAwareLock m_deadlock;
    ListLockBase!T* m_list;
    T m_data;
    Crst m_crst;
    const(char*) m_description;
    ListLockEntryBase!T* m_next;
    uint m_refCount;
    HResult m_hresultCode;
    // LOADERHANDLE
    ptrdiff_t m_initException;
    LoaderAllocator* m_allocator;

    mixin accessors;
}