module vm.listlock;

import vm.codeversioning;
import vm.crst;
import vm.threads;
import hresult;
import vm.loaderallocator;

alias ListLock = ListLockBase!uint*;
alias JitListLock = ListLockBase!NativeCodeVersion;

public struct ListLockBase(T)
{
public:
    CrstStatic crst;
    bool isfInit;
    // Lock can be broken by a host for deadlock detection
    bool hostBreakable;
    ListLockEntryBase!T* head;
}

public struct ListLockEntryBase(T)
{
public:
    DeadlockAwareLock deadlock;
    ListLockBase!T* list;
    T data;
    Crst crst;
    const char* description;
    ListLockEntryBase!T* next;
    uint refCount;
    HResult hresultCode;
    // LOADERHANDLE
    ptrdiff_t initException;
    LoaderAllocator* loaderAllocator;
}