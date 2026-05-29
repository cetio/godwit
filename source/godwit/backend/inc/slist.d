module godwit.backend.inc.slist;


public struct SLink
{
public:
final:
    SLink* next;

}

public struct SList(T)
{
public:
final:
    SLink link;
    SLink* head;
    SLink* tail;

}