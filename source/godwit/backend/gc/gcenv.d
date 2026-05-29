module godwit.backend.gc.gcenv;


public struct Thread
{
public:
final:
    bool preemptiveGCDisabled;
    uint*[16] allocContext;
    Thread* next;

}