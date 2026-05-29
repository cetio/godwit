module godwit.backend.inc.slist;


public struct SLink
{
public:
final:
    SLink* m_next;

// mixin accessors;
}

public struct SList(T)
{
public:
final:
    SLink m_link;
    SLink* m_head;
    SLink* m_tail;

// mixin accessors;
}