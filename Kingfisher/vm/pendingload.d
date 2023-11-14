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
<<<<<<< HEAD
    Exception* exception;
=======
    EXException* exception;
>>>>>>> d6d6d12 (😱😱😱)
    // m_Crst was acquired
    bool lockAcquired;
}

public struct TableEntry
{
public:
    TableEntry* next;
    uint hashValue;
    PendingTypeLoadEntry* data;
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
}