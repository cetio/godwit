module gc.gcdesc;

version(X86)
{
    alias half_size_t = ushort;
}
version(X86_64)
{
    alias half_size_t = uint;
}

// ValSeriesItem
public struct VTSeriesItem
{
    half_size_t nptrs;
    half_size_t skip;
};

// CGCDescSeries
public struct GCDescSeries
{
public:
    union
    {
        size_t seriesSize;
        VTSeriesItem[1] vtItems;
    }
    size_t startOffset;
}

// CGCDesc
public struct GCDesc
{
public:
    static size_t computeSize(size_t numSeries)
    {
        return size_t.sizeof + numSeries * CGCDescSeries.sizeof;
    }

    // For value type array
    static size_t computeSizeRepeating(size_t numSeries)
    {
        return size_t.sizeof + CGCDescSeries.sizeof +
               (numSeries - 1) * VTSeriesItem.sizeof;
    }

    size_t getNumSeries()
        scope return
    {
        return *((cast(size_t*)&this) - 1);
    }

    // Returns lowest series in memory.
    // Cannot be used for valuetype arrays
    GCDescSeries* getLowestSeries ()
    {
        return cast(GCDescSeries*)((cast(ubyte)*this) - ComputeSize(GetNumSeries()));
    }

    // Returns highest series in memory.
    GCDescSeries* getHighestSeries ()
    {
        return cast(GCDescSeries*)((cast(size_t*)&this) - 1) - 1;
    }

    // Size of the entire slot map.
    size_t GetSize ()
    {
        size_t numSeries = GetNumSeries();

        if (numSeries < 0)
            return ComputeSizeRepeating(-numSeries);

        return ComputeSize(numSeries);
    }

    ubyte* getStartOfGCData()
    {
        return (cast(ubyte*)&this) - GetSize();
    }

    bool isValueClassSeries()
    {
        // ???
        return GetNumSeries() < 0;
    }
}