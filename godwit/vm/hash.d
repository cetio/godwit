module godwit.hash;

import godwit.state;

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

    // compare object to be used in lookup
    Compare* m_compare;
    // current size (index into prime array)
    size_t m_primeIndex;
    // array of buckets
    Bucket* m_buckets;
    size_t m_prevSlotsInUse;
    // track the number of inserts and deletes
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

public struct Bucket
{
public:
    uint*[4] m_keys;
    uint*[4] m_values;

    mixin accessors;
}

public struct Compare
{
public:
    extern(C) bool function(uint*, uint*) m_fn;

    mixin accessors;
}