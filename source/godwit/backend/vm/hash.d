module godwit.backend.vm.hash;

import godwit.impl;

public struct HashMap
{
public:
final:
    enum Mode : bool
    {
        Synchronous,
        SingleUser
    }

    static if (HASHTABLE_PROFILE)
    {
        uint numRehash;
        uint numRehashSlots;
        uint numObsoleteTables;
        uint numTotalBuckets;
        uint numInsertProbesGT8;
        // HASHTABLE_LOOKUP_PROBES_DATA
        int[20] lookupProbes;
        uint* maxFailureProbe;
    }
    /// Compare object to be used in lookup
    Compare* compare;
    /// Current size (index into prime array)
    size_t primeIndex;
    /// Array of buckets
    Bucket* buckets;
    size_t prevSlotsInUse;
    /// Track the number of inserts and deletes
    size_t inserts;
    size_t deletes;
    Mode mode;
    static if (DEBUG)
    {
        void* lockData;
        FnLockOwner lockOwner;
        EEThreadId writerThreadId;
    }

}

/// Bucket acting as a dictionary with keys and values \
/// Arbitrarily sized, but must be at least length 4
public struct Bucket
{
public:
final:
    /// Bucket keys
    uint*[4] keys;
    /// Bucket values
    uint*[4] values;

}

/// Wrapper for comparisons, contains a function pointer to a comparer
public struct Compare
{
public:
final:
    /// Comparer function, to compare 2 objects (may be changed with op_x?)
    bool function(uint*, uint*) fn;

}