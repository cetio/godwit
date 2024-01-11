/// Threads & locks for atomic/async operations
module godwit.threads;

import godwit.gcenv;
import godwit.llv.traits;

/// DeadlockAwareLock is a base for building deadlock-aware locks.
/// Used for atomic thread operations (TBD)
public struct DeadlockAwareLock
{
public:
    /// Volatile
    /// The thread that this lock is maintaining
    Thread* m_holdingThread;

    mixin accessors;
}