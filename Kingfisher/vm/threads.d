module vm.threads;

import gc.gcenv;

public struct DeadlockAwareLock
{
    Thread* holdingThread;
}