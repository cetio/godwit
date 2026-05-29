module godwit.backend.vm.rcwrefcache;

import godwit.backend.vm.appdomain;
import godwit.backend.gc.qtempls;
import godwit.backend.vm.object;

public struct RCWRefCache
{
public:
final:
    AppDomain* appDomain;
    /// Internal DependentHandle cache
    /// non-NULL dependent handles followed by NULL slots
    CQuickArrayList!ObjectHandle depHndList;
    /// The starting index where depHndList has available slots
    uint depHndListFreeIndex;
    /// Keep track of how many times we use less than half handles
    uint shrinkHint;

}