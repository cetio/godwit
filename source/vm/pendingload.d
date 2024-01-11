module godwit.pendingload;

import godwit.crst;
import godwit.typehandle;
import godwit.ex;
import godwit.typekey;
import godwit.llv.traits;
import godwit.mem.state;

public struct PendingTypeLoadEntry
{
public:
    Crst m_crst;
    // Result of loading; this is first created in the CREATE stage of class loading
    TypeHandle m_typeHandle;
    TypeKey m_typeKey;
    // Number of threads waiting for this type
    int m_waitCount;
    // Error result, propagated to all threads loading this class
    HResult m_hresult;
    EXException* m_exception;
    // m_Crst was acquired
    bool m_lockAcquired;

    mixin accessors;
}

public struct TableEntry
{
public:
    TableEntry* m_next;
    uint m_hashValue;
    PendingTypeLoadEntry* m_data;

    mixin accessors;
}

public struct PendingTypeLoadTable
{
public:
    // Pointer to first entry for each bucket
    TableEntry** m_buckets;    
    uint m_numBuckets;
/*
#ifdef _DEBUG
    DWORD           m_dwDebugMemory;
#endif
*/
    mixin accessors;
}