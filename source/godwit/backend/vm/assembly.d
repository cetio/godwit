module godwit.backend.vm.assembly;

import godwit.backend.vm.ceeload;
import godwit.backend.vm.method;
import godwit.backend.vm.peassembly;
import godwit.backend.vm.loaderallocator;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.clsload;
import godwit.backend.inc.arraylist;
import godwit.backend.inc.corhdr;
import godwit.impl;

/// Equivalent to System.Runtime.Assembly.
public struct Assembly
{
public:
final:
    BaseDomain* baseDomain;
    /// Pointer to the struct loader responsible for loading types from this assembly.
    ClassLoader* classLoader;
    /// Pointer to the MethodDesc of the assembly's entrypoint, if available.
    // Entrypoint is the method that is executed first when running the assembly.
    MethodDesc* entryPoint;
    /// Module(s) owned by this assembly.
    Module* ceemodule;
    /// PE representation of this assembly.
    PEAssembly* peAssembly;
    // Friend assemblies, if applicable.
    /// Any friend assemblies associated with the assembly are able to access internal members and types.
    FriendAssemblyDescriptor* friendAssemblyDescriptor;
    /// Indicates whether this assembly is dynamically generated (e.g., at runtime).
    bool isDynamic;
    /// Indicates whether or not this assembly can be collected (unloaded) if none of the types are being used.
    static if (COLLECTIBLE_TYPES)
    {
        bool isCollectible;
    }
    /// Pointer to the loader allocator responsible for allocating memory for this assembly.
    LoaderAllocator* allocator;
    /// If a TypeLib is ever required for this module, cache the pointer here.
    // Interop Type Library
    static if (COM_INTEROP)
    {
        ubyte* itypeLib;
        uint interopAttribStatus;
    }
    DebuggerAssemblyControlFlags debuggerFlags;
    /// Indicates whether this assembly has been terminated or unloaded.
    bool isTerminated;

}

public struct FriendAssemblyDescriptor
{
public:
final:
    // Friend assemblies which have access to all internals
    ArrayList fullAccessFriendAssemblies;
    // Subject assemblies which we will not perform access checks against
    ArrayList subjectAssemblies;
    int refCount;

}