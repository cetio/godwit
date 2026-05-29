module godwit.backend.vm.listlock;

import godwit.backend.vm.codeversion;
import godwit.backend.vm.crst;
import godwit.backend.vm.threads;
import godwit.backend.vm.loaderallocator;
import godwit.hresult;

alias ListLock = ListLockBase!(void*);
alias ListLockEntry = ListLockEntryBase!(void*);
alias JitListLock = ListLockBase!NativeCodeVersion;

public struct ListLockBase(T)
{
public:
final:
    CrstStatic crst;
    bool isfInit;
    /// Lock can be broken by a host for deadlock detection
    bool hostBreakable;
    ListLockEntryBase!T* head;

}

public struct ListLockEntryBase(T)
{
public:
final:
    DeadlockAwareLock deadlock;
    ListLockBase!T* list;
    T data;
    Crst crst;
    const(char)* description;
    ListLockEntryBase!T* next;
    uint refCount;
    HResult hresultCode;
    // LOADERHANDLE
    ptrdiff_t initException;
    LoaderAllocator* allocator;

}