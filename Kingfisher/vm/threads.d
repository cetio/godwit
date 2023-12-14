module vm.threads;

import gc.gcenv;

public struct DeadlockAwareLock
{
public:
    Thread* holdingThread;

    Thread* getHoldingThread()
    {
        return holdingThread;
    }

    void setHoldingThread(Thread* newHoldingThread)
    {
        holdingThread = newHoldingThread;
    }
}