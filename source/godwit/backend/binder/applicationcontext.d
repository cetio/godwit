module godwit.backend.binder.applicationcontext;

import godwit.backend.inc.sbuffer;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.assembly;
import godwit.backend.inc.stringarraylist;
import godwit.backend.inc.shash;
import godwit.backend.binder.bspace;
import godwit.hresult;

public struct ApplicationContext
{
public:
final:
    int appVersion;
    SString applicationName;
    SHash!(BinderSpace*, uint)* executionContext;
    SHash!(FailureCacheEntry*, uint)* failureCache;
    CritSecCookie contextCS;
    StringArrayList platformResourceRoots;
    StringArrayList appPaths;
    SHash!(SimpleNameToFileNameMapEntry, uint) trustedPlatformAssemblyMap;

    //mixin accessors;
}

// Entry in SHash table that maps namespace to list of files
public struct SimpleNameToFileNameMapEntry
{
public:
final:
    wchar* simpleName;
    wchar* ilFileName;
    wchar* niFileName;

}

public struct FailureCacheEntry
{
public:
final:
    SString assemblyNameOrPath;
    HResult bindingResult;

}