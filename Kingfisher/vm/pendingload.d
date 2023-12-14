module vm.pendingload;

import vm.crst;
import vm.typehandle;
import hresult;
import inc.ex;
import vm.typekey;

public struct PendingTypeLoadEntry
{
public:
    Crst crst;
    // Result of loading; this is first created in the CREATE stage of class loading
    TypeHandle typeHandle;
    TypeKey typeKey;
    // Number of threads waiting for this type
    int waitCount;
    // Error result, propagated to all threads loading this class
    HResult hresult;
    EXException* exception;
    // m_Crst was acquired
    bool lockAcquired;

    Crst getCrst()
    {
        return crst;
    }

    void setCrst(Crst newCrst)
    {
        crst = newCrst;
    }

    TypeHandle getTypeHandle()
    {
        return typeHandle;
    }

    void setTypeHandle(TypeHandle newTypeHandle)
    {
        typeHandle = newTypeHandle;
    }

    TypeKey getTypeKey()
    {
        return typeKey;
    }

    void setTypeKey(TypeKey newTypeKey)
    {
        typeKey = newTypeKey;
    }

    int getWaitCount()
    {
        return waitCount;
    }

    void setWaitCount(int newWaitCount)
    {
        waitCount = newWaitCount;
    }

    HResult getHResult()
    {
        return hresult;
    }

    void setHResult(HResult newHResult)
    {
        hresult = newHResult;
    }

    EXException* getException()
    {
        return exception;
    }

    void setException(EXException* newException)
    {
        exception = newException;
    }

    bool getLockAcquired()
    {
        return lockAcquired;
    }

    void setLockAcquired(bool newLockAcquired)
    {
        lockAcquired = newLockAcquired;
    }

}

public struct TableEntry
{
public:
    TableEntry* next;
    uint hashValue;
    PendingTypeLoadEntry* data;

    TableEntry* getNext()
    {
        return next;
    }

    void setNext(TableEntry* newNext)
    {
        next = newNext;
    }

    uint getHashValue()
    {
        return hashValue;
    }

    void setHashValue(uint newHashValue)
    {
        hashValue = newHashValue;
    }

    PendingTypeLoadEntry* getData()
    {
        return data;
    }

    void setData(PendingTypeLoadEntry* newData)
    {
        data = newData;
    }
}

public struct PendingTypeLoadTable
{
public:
    // Pointer to first entry for each bucket
    TableEntry** buckets;    
    uint numBuckets;
/*
#ifdef _DEBUG
    DWORD           m_dwDebugMemory;
#endif
*/
    TableEntry** getBuckets()
    {
        return buckets;
    }

    void setBuckets(TableEntry** newBuckets)
    {
        buckets = newBuckets;
    }

    uint getNumBuckets()
    {
        return numBuckets;
    }

    void setNumBuckets(uint newNumBuckets)
    {
        numBuckets = newNumBuckets;
    }

}