module vm.threads;

import gc.gcenv;

public struct DeadlockAwareLock
{
public:
    Thread* holdingThread;
}