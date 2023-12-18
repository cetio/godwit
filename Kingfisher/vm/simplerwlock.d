module vm.simplerwlock;

import state;

public struct SimpleRWLock
{
public:
    // lock used for R/W synchronization
    int m_rwLock;
    // Does this lock require to be taken in PreemptiveGC mode?
    //const GC_MODE          m_gcMode;
    // spin count for a reader waiting for a writer to release the lock
    int m_spinCount;
    // used to prevent writers from being starved by readers
    // we currently do not prevent writers from starving readers since writers
    // are supposed to be rare.
    bool m_writerWaiting;
    /*
    #ifdef _DEBUG
    // Check for dead lock situation.
    Volatile<LONG>      m_countNoTriggerGC;

    #ifdef HOST_64BIT
    // ensures that we are a multiple of 8-bytes
    UINT32 pad;
    #endif
    */
    mixin accessors;
}