module vm.eehash;

import std.uuid;
import state;

public struct EEHashEntry
{
public:
    EEHashEntry* m_next;
    uint m_hashValue;
    void* m_data;
    // The key is stored inline
    ubyte m_key; 

    mixin accessors;
}

// Double buffer to fix the race condition of growhashtable (the update
// of m_pBuckets and m_dwNumBuckets has to be atomic, so we double buffer
// the structure and access it through a pointer, which can be updated
// atomically. The union is in order to not change the SOS macros.
public struct BucketTable
{
    // Pointer to first entry for each bucket
    EEHashEntry* m_buckets;
    uint m_count;
    // #ifdef TARGET_64BIT
    // "Fast Mod" multiplier for "X % m_dwNumBuckets"
    ulong m_countMul;

    mixin accessors;
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
    BucketTable* m_bucketTable;
    uint m_count;
    void* m_heap;
    int m_growing;
    /*
    #ifdef _DEBUG
    LPVOID          m_lockData;
    FnLockOwner     m_pfnLockOwner;

    EEThreadId      m_writerThreadId;
    BOOL            m_CheckThreadSafety;

    #endif 
    */
    mixin accessors;
}

public struct EEHashTable(KEY, HELPER, bool ISDEEPCOPY)
{
    EEHashTableBase!(KEY, HELPER, ISDEEPCOPY) eeHashTableBase;
    alias eeHashTableBase this;
}

public struct ClassFactoryInfo
{
public:
    UUID m_clsId;
    wchar* m_srvName;

    mixin accessors;
}

public struct EEStringData
{
public:
    // The string data.
    wchar* m_str;
    uint m_length;
    /*
    #ifdef _DEBUG
        BOOL            bDebugOnlyLowChars;      // Does the string contain only characters less than 0x80?
        DWORD           dwDebugCch;
    #endif // _DEBUG
    */  
    mixin accessors;
}

public class EEClassFactoryInfoHashTableHelper
{
    
}

alias EEUnicodeStringLiteralHashTable = EEHashTable!(EEStringData*, EEClassFactoryInfoHashTableHelper, true);