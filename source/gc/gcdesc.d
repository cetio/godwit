module godwit.gcdesc;

import godwit.methodtable;
import godwit.llv.traits;

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
public:
final:
    half_size_t m_nptrs;
    half_size_t m_skip;

    mixin accessors;
}

// CGCDescSeries
public struct GCDescSeries
{
public:
final:
    union
    {
        size_t m_seriesSize;
        VTSeriesItem m_vtItems;
    }
    size_t m_startOffset;

    mixin accessors;
}

// CGCDesc
public struct GCDesc
{
public:
final:
    pure static size_t computeSize(size_t numSeries)
    {
        return size_t.sizeof + numSeries * GCDescSeries.sizeof;
    }

    // For value type array
    pure static size_t computeSizeRepeating(size_t numSeries)
    {
        return size_t.sizeof + GCDescSeries.sizeof +
               (numSeries - 1) * VTSeriesItem.sizeof;
    }

    // Returns number of immediate pointers this object has. It should match the number of
    // pointers enumerated by go_through_object_cl macro. The implementation shape has intentional
    // similarity with the go_through_object family of macros.
    // size is only used if you have an array of value types.
//#ifndef DACCESS_COMPILE
    static int getNumPointers(MethodTable* pmt, uint size, uint numComps)
    {
        /+if (!pmt.containsPointers)
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
        return count;+/
        return 0;
    }

    size_t getNumSeries() const
        scope return
    {
        return *((cast(size_t*)&this) - 1);
    }

    // Returns lowest series in memory.
    // Cannot be used for valuetype arrays
    GCDescSeries* getLowestSeries()
        scope return
    {
        return cast(GCDescSeries*)((cast(ubyte*)&this) - computeSize(getNumSeries()));
    }

    // Returns highest series in memory.
    GCDescSeries* getHighestSeries()
        scope return
    {
        return cast(GCDescSeries*)((cast(size_t*)&this) - 1) - 1;
    }

    // Size of the entire slot map.
    size_t getSize() const
    {
        size_t numSeries = getNumSeries();

        if (numSeries < 0)
            return computeSizeRepeating(-numSeries);

        return computeSize(numSeries);
    }

    ubyte* getStartOfGCData()
        scope return
    {
        return (cast(ubyte*)&this) - getSize();
    }

    bool isValueClassSeries() const
    {
        // ???
        return getNumSeries() < 0;
    }
}