module godwit.comreflectioncache;

import godwit.simplerwlock;
import godwit.methodtable;

public struct ReflectionCache(ELEM, TYPE, int SIZE)
{
    SimpleRWLock simpleRWLock;
    alias simpleRWLock this;

public:
    int index;
    int stamp;
}

public struct DispIDCacheElement
{
public:
    MethodTable* methodTable;
    int nameLength;
    uint lcId;
    int dispId;
    wchar[24] name;
}

alias DispIDCache = ReflectionCache!(DispIDCacheElement, int, 128);