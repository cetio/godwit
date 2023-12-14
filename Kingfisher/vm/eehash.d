module vm.eehash;

import std.uuid;

public struct EEHashEntry
{
public:
    EEHashEntry* next;
    uint hashValue;
    void* data;
    // The key is stored inline
    ubyte key; 

    EEHashEntry* getNext()
    {
        return next;
    }

    void setNext(EEHashEntry* newNext)
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

    void* getData()
    {
        return data;
    }

    void setData(void* newData)
    {
        data = newData;
    }

    ubyte getKey()
    {
        return key;
    }

    void setKey(ubyte newKey)
    {
        key = newKey;
    }
}

// Double buffer to fix the race condition of growhashtable (the update
// of m_pBuckets and m_dwNumBuckets has to be atomic, so we double buffer
// the structure and access it through a pointer, which can be updated
// atomically. The union is in order to not change the SOS macros.
public struct BucketTable
{
    // Pointer to first entry for each bucket
    EEHashEntry* buckets;
    uint count;
    // #ifdef TARGET_64BIT
    // "Fast Mod" multiplier for "X % m_dwNumBuckets"
    ulong countMul;

    EEHashEntry* getBuckets()
    {
        return buckets;
    }

    void setBuckets(EEHashEntry* newBuckets)
    {
        buckets = newBuckets;
    }

    uint getCount()
    {
        return count;
    }

    void setCount(uint newCount)
    {
        count = newCount;
    }

    ulong getCountMul()
    {
        return countMul;
    }

    void setCountMul(ulong newCountMul)
    {
        countMul = newCountMul;
    }
}

public struct EEHashTableBase(KEY, HELPER, bool ISDEEPCOPY)
{
public:
    // In a function we MUST only read this value ONCE, as the writer thread can change
    // the value asynchronously. We make this member volatile the compiler won't do copy propagation
    // optimizations that can make this read happen more than once. Note that we  only need
    // this property for the readers. As they are the ones that can have
    // this variable changed (note also that if the variable was enregistered we wouldn't
    // have any problem)
    // BE VERY CAREFUL WITH WHAT YOU DO WITH THIS VARIABLE AS USING IT BADLY CAN CAUSE
    // RACING CONDITIONS
    BucketTable* bucketTable;
    uint count;
    void* heap;
    int growing;
    /*
    #ifdef _DEBUG
    LPVOID          m_lockData;
    FnLockOwner     m_pfnLockOwner;

    EEThreadId      m_writerThreadId;
    BOOL            m_CheckThreadSafety;

    #endif 
    */
    BucketTable* getBucketTable()
    {
        return bucketTable;
    }

    void setBucketTable(BucketTable* newBucketTable)
    {
        bucketTable = newBucketTable;
    }

    uint getCount()
    {
        return count;
    }

    void setCount(uint newCount)
    {
        count = newCount;
    }

    void* getHeap()
    {
        return heap;
    }

    void setHeap(void* newHeap)
    {
        heap = newHeap;
    }

    int getGrowing()
    {
        return growing;
    }

    void setGrowing(int newGrowing)
    {
        growing = newGrowing;
    }
}

public struct EEHashTable(KEY, HELPER, bool ISDEEPCOPY)
{
    EEHashTableBase!(KEY, HELPER, ISDEEPCOPY) eeHashTableBase;
    alias eeHashTableBase this;
}

public struct ClassFactoryInfo
{
public:
    UUID clsId;
    wchar* srvName;

    UUID getClsId()
    {
        return clsId;
    }

    void setClsId(UUID newClsId)
    {
        clsId = newClsId;
    }

    wchar* getSrvName()
    {
        return srvName;
    }

    void setSrvName(wchar* newSrvName)
    {
        srvName = newSrvName;
    }
}

public struct EEStringData
{
public:
    // The string data.
    wchar* string;
    uint length;
    /*
    #ifdef _DEBUG
        BOOL            bDebugOnlyLowChars;      // Does the string contain only characters less than 0x80?
        DWORD           dwDebugCch;
    #endif // _DEBUG
    */  
    wchar* getString()
    {
        return string;
    }

    void setString(wchar* newString)
    {
        string = newString;
    }

    uint getLength()
    {
        return length;
    }

    void setLength(uint newLength)
    {
        length = newLength;
    }
}

public class EEClassFactoryInfoHashTableHelper
{
    
}

alias EEUnicodeStringLiteralHashTable = EEHashTable!(EEStringData*, EEClassFactoryInfoHashTableHelper, true);