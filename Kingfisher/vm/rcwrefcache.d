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
}