module godwit.backend.vm.comreflectioncache;

import godwit.backend.simplerwlock;
import godwit.backend.vm.methodtable;

public struct ReflectionCache(ELEM, TYPE, int SIZE)
{
    SimpleRWLock simpleRWLock;
    alias simpleRWLock this;

public:
final:
    int index;
    int stamp;

}

public struct DispIDCacheElement
{
public:
final:
    MethodTable* methodTable;
    int nameLength;
    uint lcId;
    int dispId;
    wchar[24] name;

}

alias DispIDCache = ReflectionCache!(DispIDCacheElement, int, 128);