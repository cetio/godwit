module inc.shash;

public struct SHash(ELEM, COUNT)
{
public:
    ELEM* table;
    COUNT size;
    COUNT count;
    COUNT occupied;
    COUNT max;
}