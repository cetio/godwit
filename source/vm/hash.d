module godwit.hash;

import godwit.collections.state;

public struct HashMap
{
public:
    /*
#ifdef HASHTABLE_PROFILE
    unsigned    m_cbRehash;    // number of times rehashed
    unsigned    m_cbRehashSlots; // number of slots that were rehashed
    unsigned    m_cbObsoleteTables;
    unsigned    m_cbTotalBuckets;
    unsigned    m_cbInsertProbesGt8; // inserts that needed more than 8 probes
    LONG        m_rgLookupProbes[HASHTABLE_LOOKUP_PROBES_DATA]; // lookup probes
    UPTR        maxFailureProbe; // cost of failed lookup
#endif // HASHTABLE_PROFILE
    */
    enum Mode : bool
    {
        Synchronous,
        SingleUser
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
    /*
#ifdef _DEBUG
    LPVOID          m_lockData;
    FnLockOwner     m_pfnLockOwner;
    EEThreadId      m_writerThreadId;
#endif // _DEBUG
    */
    mixin accessors;
}

/// Bucket acting as a dictionary with keys and values
///
/// Arbitrarily sized, but must be at least length 4
public struct Bucket
{
public:
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
    /// Comparer function, to compare 2 objects (may be changed with op_x?)
    bool function(uint*, uint*) m_fn;

    mixin accessors;
}