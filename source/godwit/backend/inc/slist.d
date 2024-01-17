module godwit.backend.slist;

import caiman.traits;

public struct SLink
{
public:
final:
    SLink* m_next;

    mixin accessors;
}

public struct SList(T)
{
public:
final:
    SLink m_link;
    SLink* m_head;
    SLink* m_tail;

    mixin accessors;
}