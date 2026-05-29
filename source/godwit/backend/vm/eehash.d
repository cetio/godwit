module godwit.backend.vm.eehash;

import std.uuid;
import godwit.impl;

public struct EEHashEntry
{
public:
final:
    EEHashEntry* next;
    uint hashValue;
    void* data;
    /// The key is stored inline
    ubyte key;

}

// Double buffer to fix the race condition of growhashtable (the update
// of buckets and numBuckets has to be atomic, so we double buffer
// the structure and access it through a pointer, which can be updated
// atomically. The union is in order to not change the SOS macros.
public struct BucketTable
{
public:
final:
    /// Pointer to first entry for each bucket
    EEHashEntry* buckets;
    uint count;
    static if (TARGET_x64)
    {
        /// "Fast Mod" multiplier for "X % numBuckets"
        ulong countMul;
    }

}

public struct EEHashTableBase(KEY, HELPER, bool ISDEEPCOPY)
{
public:
    // In a function we MUST only read this value ONCE, as the writer thread can change
    // the value asynchronously. We make this member volatile the compiler won't do copy propagation
    // optimizations that can make this read happen more than once. Note that we  only need
    // this property for the godwit. As they are the ones that can have
    // this variable changed (note also that if the variable was enregistered we wouldn't
    // have any problem)
    // BE VERY CAREFUL WITH WHAT YOU DO WITH THIS VARIABLE AS USING IT BADLY CAN CAUSE
    // RACING CONDITIONS
    BucketTable* bucketTable;
    uint count;
    void* heap;
    int growing;
    static if (DEBUG)
    {
        void* lockData;
        FnLockOwner lockOwner;
        EEThreadId writerThreadId;
        bool checkThreadSafety;
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
final:
    UUID clsId;
    wchar* srvName;

}

public struct EEStringData
{
public:
final:
    /// The string data.
    wchar* str;
    uint length;
    static if (DEBUG)
    {
        bool debugOnlyLowChars;
        uint debugCch;
    }

}

public class EEClassFactoryInfoHashTableHelper
{

}

alias EEUnicodeStringLiteralHashTable = EEHashTable!(EEStringData*, EEClassFactoryInfoHashTableHelper, true);