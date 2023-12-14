module vm.rcwrefcache;

import vm.appdomain;
import gc.qtempls;
import vm.objects;

public struct RCWRefCache
{
public:
    AppDomain* appDomain;
    // Internal DependentHandle cache
    // non-NULL dependent handles followed by NULL slots
    CQuickArrayList!ObjectHandle depHndList;
    // The starting index where m_depHndList has available slots
    uint depHndListFreeIndex;
    // Keep track of how many times we use less than half handles
    uint shrinkHint;

    AppDomain* getAppDomain()
    {
        return appDomain;
    }

    CQuickArrayList!ObjectHandle getDepHndList()
    {
        return depHndList;
    }

    uint getDepHndListFreeIndex()
    {
        return depHndListFreeIndex;
    }

    uint getShrinkHint()
    {
        return shrinkHint;
    }

    void setAppDomain(AppDomain* newAppDomain)
    {
        appDomain = newAppDomain;
    }

    void setDepHndList(CQuickArrayList!ObjectHandle newDepHndList)
    {
        depHndList = newDepHndList;
    }

    void setDepHndListFreeIndex(uint newFreeIndex)
    {
        depHndListFreeIndex = newFreeIndex;
    }

    void setShrinkHint(uint newShrinkHint)
    {
        shrinkHint = newShrinkHint;
    }
}