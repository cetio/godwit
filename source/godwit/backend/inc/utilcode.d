module godwit.backend.inc.utilcode;

import godwit.impl;


public struct RangeList
{
public:
final:
    size_t vtablePtr;
    RangeListBlock starterBlock;
    RangeListBlock* firstEmptyBlock;
    size_t firstEmptyRange;

}

public struct LockedRangeList
{
public:
final:
    RangeList base;
    static if (DEBUG)
    {
        size_t[3] rwLock;
    }
    else
    {
        size_t[2] rwLock;
    }

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