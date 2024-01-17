module godwit.backend.hash;

import caiman.traits;
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
        uint m_numRehash;
        uint m_numRehashSlots;
        uint m_numObsoleteTables;
        uint m_numTotalBuckets;
        uint m_numInsertProbesGT8;
        // HASHTABLE_LOOKUP_PROBES_DATA
        int[20] m_lookupProbes;
        uint* maxFailureProbe;
    }
    /// Compare object to be used in lookup
    Compare* m_compare;
    /// Current size (index into prime array)
    size_t m_primeIndex;
    /// Array of buckets
    Bucket* m_buckets;
    size_t m_prevSlotsInUse;
    /// Track the number of inserts and deletes
    size_t m_inserts;
    size_t m_deletes;
    Mode m_mode;
    static if (DEBUG)
    {
        void* m_lockData;
        FnLockOwner m_lockOwner;
        EEThreadId m_writerThreadId;
    }

    mixin accessors;
}

/// Bucket acting as a dictionary with keys and values \
/// Arbitrarily sized, but must be at least length 4
public struct Bucket
{
public:
final:
    /// Bucket keys
    uint*[4] m_keys;
    /// Bucket values
    uint*[4] m_values;

    mixin accessors;
}

/// Wrapper for comparisons, contains a function pointer to a comparer
public struct Compare
{
public:
final:
    /// Comparer function, to compare 2 objects (may be changed with op_x?)
    @exempt bool function(uint*, uint*) fn;

    mixin accessors;
}