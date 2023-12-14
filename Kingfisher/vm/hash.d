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
    Compare* getCompare()
    {
        return compare;
    }

    void setCompare(Compare* newCompare)
    {
        compare = newCompare;
    }

    size_t getPrimeIndex()
    {
        return primeIndex;
    }

    void setPrimeIndex(size_t newPrimeIndex)
    {
        primeIndex = newPrimeIndex;
    }

    Bucket* getBuckets()
    {
        return buckets;
    }

    void setBuckets(Bucket* newBuckets)
    {
        buckets = newBuckets;
    }

    size_t getPrevSlotsInUse()
    {
        return prevSlotsInUse;
    }

    void setPrevSlotsInUse(size_t newPrevSlotsInUse)
    {
        prevSlotsInUse = newPrevSlotsInUse;
    }

    size_t getInserts()
    {
        return inserts;
    }

    void setInserts(size_t newInserts)
    {
        inserts = newInserts;
    }

    size_t getDeletes()
    {
        return deletes;
    }

    void setDeletes(size_t newDeletes)
    {
        deletes = newDeletes;
    }

    Mode getMode()
    {
        return mode;
    }

    void setMode(Mode newMode)
    {
        mode = newMode;
    }

    bool isSynchronous()
    {
        return mode == Mode.Synchronous;
    }

    bool setIsSynchronous(bool state)
    {
        return mode = state ? Mode.Synchronous : Mode.SingleUser;
    }

    bool isSingleUser()
    {
        return mode == Mode.SingleUser;
    }

    bool setIsSingleUser(bool state)
    {
        return mode = state ? Mode.SingleUser : Mode.Synchronous;
    }
}

public struct Bucket
{
public:
    uint*[4] keys;
    uint*[4] values;

    uint*[4] getKeys()
    {
        return keys;
    }

    void setKeys(uint*[4] newKeys)
    {
        keys = newKeys;
    }

    uint*[4] getValues()
    {
        return values;
    }

    void setValues(uint*[4] newValues)
    {
        values = newValues;
    }

}

public struct Compare
{
public:
    extern(C) bool function(uint*, uint*) fn;

    bool function(uint*, uint*) getFn()
    {
        return fn;
    }

    void setFn(bool function(uint*, uint*) newFn)
    {
        fn = newFn;
    }
}