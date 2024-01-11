module godwit.defaultassemblybinder;

import godwit.assemblybinder;

public struct DefaultAssemblyBinder
{
    AssemblyBinder assemblyBinder;
    alias assemblyBinder this;

    // mixin metadata;
    pragma(mangle, "DefaultAssemblyBinder_ignore_metadata_void")
    extern (C) export void __ignore() { }
}