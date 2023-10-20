module gc.gcenv;

public struct Thread
{
public:
    bool preemptiveGCDisabled;
    uint*[16] allocContext;
    Thread* next;
}