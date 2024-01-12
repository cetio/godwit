module godwit.comreflectioncache;

import godwit.simplerwlock;
import godwit.methodtable;
import godwit.llv.traits;

public struct ReflectionCache(ELEM, TYPE, int SIZE)
{
    SimpleRWLock simpleRWLock;
    alias simpleRWLock this;

public:
final:
    int m_index;
    int m_stamp;

    mixin accessors;
}

public struct DispIDCacheElement
{
public:
final:
    MethodTable* m_methodTable;
    int m_nameLength;
    uint m_lcId;
    int m_dispId;
    wchar[24] m_name;

    mixin accessors;
}

alias DispIDCache = ReflectionCache!(DispIDCacheElement, int, 128);