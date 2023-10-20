module vm.hash;

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
    Compare* compare;
    // current size (index into prime array)
    size_t primeIndex;
    // array of buckets
    Bucket* buckets;
    size_t prevSlotsInUse;
    // track the number of inserts and deletes
    size_t inserts;
    size_t deletes;
    Mode mode;
    /*
#ifdef _DEBUG
    LPVOID          m_lockData;
    FnLockOwner     m_pfnLockOwner;
    EEThreadId      m_writerThreadId;
#endif // _DEBUG
    */
}

public struct Bucket
{
public:
    uint*[4] keys;
    uint*[4] values;
}

public struct Compare
{
public:
    extern(C) bool function(uint*, uint*) fnptr;
}