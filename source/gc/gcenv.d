module godwit.gcenv;

import godwit.mem.state;

public struct Thread
{
public:
    bool m_preemptiveGCDisabled;
    uint*[16] m_allocContext;
    Thread* m_next;

    mixin accessors;
}