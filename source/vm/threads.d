module godwit.threads;

import godwit.gcenv;
import godwit.state;

public struct DeadlockAwareLock
{
public:
    Thread* m_holdingThread;

    mixin accessors;
}