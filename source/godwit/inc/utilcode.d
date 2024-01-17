module godwit.utilcode;

import caiman.traits;

public struct RangeList
{
public:
final:
    RangeListBlock m_starterBlock;
    RangeListBlock* m_firstEmptyBlock;
    uint* m_firstEmptyRange;

    mixin accessors;
}

public struct Range
{
public:
final:
    uint* m_start;
    uint* m_end;
    uint* m_id;

    mixin accessors;
}

public struct RangeListBlock
{
public:
final:
    // RANGE_COUNT
    Range[10] m_ranges;
    RangeListBlock* m_next;

    mixin accessors;
}