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

// GCDesc
public struct GCDesc
{

}