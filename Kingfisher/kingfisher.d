module kingfisher;

import core.sys.windows.windows;
import core.sys.windows.dll;
import vm.appdomain;

mixin SimpleDllMain;

public static AppDomain* appDomain;

extern (C) export void Initialize(AppDomain* pdom)
{
    appDomain = pdom;
}