/// Threads & locks for atomic/async operations
module godwit.threads;

import godwit.gcenv;
import caiman.traits;
import godwit.impl;

/// DeadlockAwareLock is a base for building deadlock-aware locks.
/// Used for atomic thread operations (TBD)
public struct DeadlockAwareLock
{
public:
final:
    /// Volatile
    /// The thread that this lock is maintaining
    Thread* m_holdingThread;
    static if (DEBUG)
    {
        const(char*) m_description;
    }

    mixin accessors;
}