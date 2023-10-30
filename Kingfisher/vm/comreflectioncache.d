module vm.comreflectioncache;

import vm.simplerwlock;
import vm.methodtable;

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