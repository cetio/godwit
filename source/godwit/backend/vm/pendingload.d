module godwit.backend.vm.pendingload;

import godwit.backend.vm.crst;
import godwit.backend.vm.typehandle;
import godwit.backend.inc.ex;
import godwit.backend.vm.typekey;
import godwit.impl;
import godwit.hresult;

public struct PendingTypeLoadEntry
{
public:
final:
    Crst crst;
    /// Result of loading; this is first created in the CREATE stage of class loading
    TypeHandle typeHandle;
    TypeKey typeKey;
    /// Number of threads waiting for this type
    int waitCount;
    /// Error result, propagated to all threads loading this class
    HResult hresult;
    EXException* exception;
    /// Crst was acquired
    bool lockAcquired;

}

public struct TableEntry
{
public:
final:
    TableEntry* next;
    uint hashValue;
    PendingTypeLoadEntry* data;

}

public struct PendingTypeLoadTable
{
public:
final:
    /// Pointer to first entry for each bucket
    TableEntry** buckets;
    uint numBuckets;
    static if (DEBUG)
    {
        uint numDebugMemory;
    }

}