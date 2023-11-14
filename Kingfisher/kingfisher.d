module kingfisher;

import core.sys.windows.windows;
import core.sys.windows.dll;
import vm.appdomain;
<<<<<<< HEAD

mixin SimpleDllMain;

public static AppDomain* appDomain;

extern (C) export void Initialize(AppDomain* pdom)
{
    appDomain = pdom;
=======
import vm.ceeload;
import vm.methodtable;
import vm.assembly;
import vm.loaderallocator;
import std.stdio;
import vm.eeclass;

mixin SimpleDllMain;

extern (C) export void Initialize(Module* pmd)
{
    foreach (i, field; pmd.tupleof)
    {
        writefln(Module.tupleof[i].stringof ~ " = %s", field);
    }
>>>>>>> d6d6d12 (😱😱😱)
}