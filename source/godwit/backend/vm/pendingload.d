module godwit.backend.pendingload;

import godwit.backend.crst;
import godwit.backend.typehandle;
import godwit.backend.ex;
import godwit.backend.typekey;
import caiman.traits;
import caiman.state;
import godwit.impl;

public struct PendingTypeLoadEntry
{
public:
final:
    Crst m_crst;
    /// Result of loading; this is first created in the CREATE stage of class loading
    TypeHandle m_typeHandle;
    TypeKey m_typeKey;
    /// Number of threads waiting for this type
    int m_waitCount;
    /// Error result, propagated to all threads loading this class
    HResult m_hresult;
    EXException* m_exception;
    /// m_Crst was acquired
    bool m_lockAcquired;

    mixin accessors;
}

public struct TableEntry
{
public:
final:
    TableEntry* m_next;
    uint m_hashValue;
    PendingTypeLoadEntry* m_data;

    mixin accessors;
}

public struct PendingTypeLoadTable
{
public:
final:
    /// Pointer to first entry for each bucket
    TableEntry** m_buckets;    
    uint m_numBuckets;
    static if (DEBUG)
    {
        uint m_numDebugMemory;
    }
    
    mixin accessors;
}