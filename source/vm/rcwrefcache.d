module godwit.rcwrefcache;

import godwit.appdomain;
import godwit.qtempls;
import godwit.objects;
import godwit.mem.state;

public struct RCWRefCache
{
public:
    AppDomain* m_appDomain;
    // Internal DependentHandle cache
    // non-NULL dependent handles followed by NULL slots
    CQuickArrayList!ObjectHandle m_depHndList;
    // The starting index where m_depHndList has available slots
    uint m_depHndListFreeIndex;
    // Keep track of how many times we use less than half handles
    uint m_shrinkHint;

    mixin accessors;
}