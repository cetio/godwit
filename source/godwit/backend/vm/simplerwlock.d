module godwit.backend.simplerwlock;

import caiman.traits;
import godwit.impl;

public struct SimpleRWLock
{
public:
final:
    enum GC_MODE 
    {
        COOPERATIVE,
        PREEMPTIVE,
        EITHER
    }

    /// Lock used for R/W synchronization
    int m_rwLock;
    /// Does this lock require to be taken in PreemptiveGC mode?
    const GC_MODE m_gcMode;
    /// Spin count for a reader waiting for a writer to release the lock
    int m_spinCount;
    /// Used to prevent writers from being starved by readers \
    /// We currently do not prevent writers from starving readers since writers
    /// are supposed to be rare.
    bool m_writerWaiting;
    static if (DEBUG)
    {
        /// Check for dead lock situation.
        int m_countNoTriggerGC;
        static if (HOST_x64)
        {
            /// Ensures that we are a multiple of 8-bytes
            uint pad;
        }
    }
    
    mixin accessors;
}