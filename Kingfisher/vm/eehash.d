module vm.eehash;

<<<<<<< HEAD
=======
import std.uuid;

>>>>>>> d6d6d12 (😱😱😱)
public struct EEHashEntry
{
public:
    EEHashEntry* next;
    uint hashValue;
    void* data;
    ubyte[1] key; // The key is stored inline
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

<<<<<<< HEAD
    #endif
=======
    #endif 
>>>>>>> d6d6d12 (😱😱😱)
    */
}

public struct EEHashTable(KEY, HELPER, bool ISDEEPCOPY)
{
<<<<<<< HEAD
    EEHashTableBase(KEY, HELPER, ISDEEPCOPY) eeHashTableBase;
=======
    EEHashTableBase!(KEY, HELPER, ISDEEPCOPY) eeHashTableBase;
>>>>>>> d6d6d12 (😱😱😱)
    alias eeHashTableBase this;
}

public struct ClassFactoryInfo
{
public:
<<<<<<< HEAD
    Uuid clsId;
=======
    UUID clsId;
>>>>>>> d6d6d12 (😱😱😱)
    wchar* srvName;
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
}

public class EEClassFactoryInfoHashTableHelper
{
    
}

<<<<<<< HEAD
alias EEUnicodeStringLiteralHashTable = EEHashTable(EEStringData*, EEClassFactoryInfoHashTableHelper, true)
=======
alias EEUnicodeStringLiteralHashTable = EEHashTable!(EEStringData*, EEClassFactoryInfoHashTableHelper, true);
>>>>>>> d6d6d12 (😱😱😱)
