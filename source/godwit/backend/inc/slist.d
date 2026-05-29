module godwit.backend.inc.slist;


public struct SLink
{
public:
final:
    SLink* m_next;

}

public struct SList(T)
{
public:
final:
    SLink m_link;
    SLink* m_head;
    SLink* m_tail;

}