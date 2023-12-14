module gc.gcenv;

public struct Thread
{
public:
    bool preemptiveGCDisabled;
    uint*[16] allocContext;
    Thread* next;

    bool getPreemptiveGCDisabled()
    {
        return preemptiveGCDisabled;
    }

    void setPreemptiveGCDisabled(bool state)
    {
        preemptiveGCDisabled = state;
    }

    uint*[] getAllocContext()
    {
        return allocContext;
    }

    void setAllocContext(uint*[] newAllocContext)
    {
        allocContext = newAllocContext.dup;
    }

    Thread* getNext()
    {
        return next;
    }

    void setNext(Thread* newNext)
    {
        next = newNext;
    }
}