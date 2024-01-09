module godwit.main;

import core.sys.windows.windows;
import core.sys.windows.windef : HINSTANCE, BOOL, DWORD, LPVOID;
import core.sys.windows.dll;
import godwit.vm;
import godwit.collections;
import std.stdio;

static AppDomain* appDomain;
public static void function() onInitialize;

extern(Windows)
BOOL DllMain(HINSTANCE hInstance, DWORD ulReason, LPVOID reserved)
{
    onInitialize = &test;
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
}

void test()
{
    writeln("This is a hook!");
}

//extern (C) export void initialize(AppDomain* pDOM)
extern (C) export void initialize(Module* pMOD)
{
    //appDomain = pDOM;
    writeln("Initialized! ", pMOD);

    if (onInitialize != null)
        onInitialize();
}