module godwit.listlock;

import godwit.codeversioning;
import godwit.crst;
import godwit.threads;
import godwit.loaderallocator;
import godwit.collections.state;

alias ListLock = ListLockBase!uint*;
alias JitListLock = ListLockBase!NativeCodeVersion;

public struct ListLockBase(T)
{
public:
    CrstStatic m_crst;
    bool m_isfInit;
    // Lock can be broken by a host for deadlock detection
    bool m_hostBreakable;
    ListLockEntryBase!T* m_head;

    mixin accessors;
}

public struct ListLockEntryBase(T)
{
public:
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