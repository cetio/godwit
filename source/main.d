module godwit.main;

import core.sys.windows.windows;
import core.sys.windows.windef : HINSTANCE, BOOL, DWORD, LPVOID;
import core.sys.windows.dll;
import godwit.vm;
import godwit.mem;
import godwit.llv;
import std.stdio;
import std.conv;

static AppDomain* appDomain;
public static bool function() onInitialize;

/* extern(Windows)
BOOL DllMain(HINSTANCE hInstance, DWORD ulReason, LPVOID reserved)
{
    import core.sys.windows.winnt;
    import core.sys.windows.dll :
        dll_process_attach, dll_process_detach,
        dll_thread_attach, dll_thread_detach;
    switch (ulReason)
    {
        default: assert(0);
        case DLL_PROCESS_ATTACH:
            return dll_process_attach( hInstance, true );

        case DLL_PROCESS_DETACH:
            dll_process_detach( hInstance, true );
            return true;

        case DLL_THREAD_ATTACH:
            return dll_thread_attach( true, true );

        case DLL_THREAD_DETACH:
            return dll_thread_detach( true, true );
    }
} */

void main()
{
    initialize(null);
}

//extern (C) export void initialize(AppDomain* pDom)
extern (C) export bool initialize(Module* pMod)
{
    //appDomain = pDOM;
    writeln("Initialized! ", pMod);
    import godwit.formats.make;
    make!(godwit.vm, "C:\\Users\\stake\\Documents").csharp("ICLR");
    make!(godwit.inc, "C:\\Users\\stake\\Documents").csharp("ICLR");
    make!(godwit.gc, "C:\\Users\\stake\\Documents").csharp("ICLR");
    make!(godwit.binder, "C:\\Users\\stake\\Documents").csharp("ICLR");
    auto pAsm = pMod.peAssembly;
    pAsm.writeln;
    import std.traits;
    foreach (field; FieldNameTuple!PEAssembly)
    {
        writeln(field, " ", __traits(getMember, pAsm, field).to!string);
    }

    if (onInitialize != null)
        return onInitialize();
    return true;
}