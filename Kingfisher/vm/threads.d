module vm.threads;

import gc.gcenv;
import state;

public struct DeadlockAwareLock
{
public:
    Thread* m_holdingThread;

    mixin accessors;
}