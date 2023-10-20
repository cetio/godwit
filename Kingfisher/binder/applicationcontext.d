module binder.applicationcontext;

import inc.sbuffer;
import inc.corhdr;
import binder.assembly;
import inc.stringarraylist;
import inc.shash;
import hresult;

public struct ApplicationContext
{
public:
    int appVersion;
    SString applicationName;
    SHash!(BinderSpace*, uint)* executionContext;
    SHash!(FailureCacheEntry*, uint)* failureCache;
    CritSecCookie contextCS;
    StringArrayList platformResourceRoots;
    StringArrayList appPaths;
    SHash!(SimpleNameToFileNameMapEntry, uint) trustedPlatformAssemblyMap;
}

// Entry in SHash table that maps namespace to list of files
public struct SimpleNameToFileNameMapEntry
{
public:
    wchar* simpleName;
    wchar* ilFileName;
    wchar* niFileName;
};

public struct FailureCacheEntry
{
public:
    SString assemblyNameOrPath;
    HResult bindingResult;
}