module godwit.backend.inc.utilcode;


public struct RangeList
{
public:
final:
    RangeListBlock starterBlock;
    RangeListBlock* firstEmptyBlock;
    uint* firstEmptyRange;

}

public struct Range
{
public:
final:
    uint* start;
    uint* end;
    uint* id;

}

public struct RangeListBlock
{
public:
final:
    // RANGE_COUNT
    Range[10] ranges;
    RangeListBlock* next;

}