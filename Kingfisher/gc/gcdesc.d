module gc.gcdesc;

import vm.methodtable;

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

    size_t getSeriesSize()
    {
        return seriesSize;
    }

<<<<<<< HEAD
    VTSeriesItem[] getVTItems
=======
    VTSeriesItem[] getVTItems()
>>>>>>> d6d6d12 (😱😱😱)
    {
        return vtItems;
    }

    size_t getStartOffset()
    {
        return startOffset;
    }
}

// CGCDesc
public struct GCDesc
{
public:
<<<<<<< HEAD
    static size_t computeSize(size_t numSeries) const
    {
        return size_t.sizeof + numSeries * CGCDescSeries.sizeof;
    }

    // For value type array
    static size_t computeSizeRepeating(size_t numSeries) const
    {
        return size_t.sizeof + CGCDescSeries.sizeof +
=======
    static size_t computeSize(size_t numSeries)
    {
        return size_t.sizeof + numSeries * GCDescSeries.sizeof;
    }

    // For value type array
    static size_t computeSizeRepeating(size_t numSeries)
    {
        return size_t.sizeof + GCDescSeries.sizeof +
>>>>>>> d6d6d12 (😱😱😱)
               (numSeries - 1) * VTSeriesItem.sizeof;
    }

    // Returns number of immediate pointers this object has. It should match the number of
    // pointers enumerated by go_through_object_cl macro. The implementation shape has intentional
    // similarity with the go_through_object family of macros.
    // size is only used if you have an array of value types.
//#ifndef DACCESS_COMPILE
<<<<<<< HEAD
    static int getNumPointers(MethodTable* pmt, uint size, uint numComps) const
    {
        if (!pmt.containsPointers)
=======
    static int getNumPointers(MethodTable* pmt, uint size, uint numComps)
    {
        /+if (!pmt.containsPointers)
>>>>>>> d6d6d12 (😱😱😱)
            return 0;

        int count = 0;
        GCDesc* map = pmt.getGCDesc();
        GCDescSeries* cur = map.getHighestSeries();
        size_t numSeries = map.getNumSeries();

        if (numSeries >= 0)
        {
            GCDescSeries* last = map.getLowestSeries();
            do
            {
                count += (cur.getSeriesSize() + size) / size_t.sizeof;
                cur--;
            } while (cur >= last);
        }
        else
        {
            // Handle the repeating case - array of valuetypes
            for (int i = 0; i > numSeries; i--)
                count += (cur.vtItems + i).nptrs;

            count *= numComps;
        }
/*
#ifndef FEATURE_NATIVEAOT
        if (pmt->Collectible())
        {
            NumOfPointers += 1;
        }
#endif
*/
<<<<<<< HEAD
        return count;
=======
        return count;+/
        return 0;
>>>>>>> d6d6d12 (😱😱😱)
    }

    size_t getNumSeries() const
        scope return
    {
        return *((cast(size_t*)&this) - 1);
    }

    // Returns lowest series in memory.
    // Cannot be used for valuetype arrays
    GCDescSeries* getLowestSeries()
    {
<<<<<<< HEAD
        return cast(GCDescSeries*)((cast(ubyte)*this) - ComputeSize(GetNumSeries()));
=======
        return cast(GCDescSeries*)((cast(ubyte*)&this) - computeSize(getNumSeries()));
>>>>>>> d6d6d12 (😱😱😱)
    }

    // Returns highest series in memory.
    GCDescSeries* getHighestSeries()
    {
        return cast(GCDescSeries*)((cast(size_t*)&this) - 1) - 1;
    }

    // Size of the entire slot map.
<<<<<<< HEAD
    size_t GetSize() const
    {
        size_t numSeries = GetNumSeries();

        if (numSeries < 0)
            return ComputeSizeRepeating(-numSeries);

        return ComputeSize(numSeries);
=======
    size_t getSize() const
    {
        size_t numSeries = getNumSeries();

        if (numSeries < 0)
            return computeSizeRepeating(-numSeries);

        return computeSize(numSeries);
>>>>>>> d6d6d12 (😱😱😱)
    }

    ubyte* getStartOfGCData()
    {
<<<<<<< HEAD
        return (cast(ubyte*)&this) - GetSize();
=======
        return (cast(ubyte*)&this) - getSize();
>>>>>>> d6d6d12 (😱😱😱)
    }

    bool isValueClassSeries() const
    {
        // ???
<<<<<<< HEAD
        return GetNumSeries() < 0;
=======
        return getNumSeries() < 0;
>>>>>>> d6d6d12 (😱😱😱)
    }
}