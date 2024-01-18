module godwit.backend.vm.assembly;

import godwit.backend.vm.ceeload;
import godwit.backend.vm.method;
import godwit.backend.vm.peassembly;
import godwit.backend.vm.loaderallocator;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.clsload;
import godwit.backend.inc.arraylist;
import godwit.backend.inc.corhdr;
import caiman.traits;
import godwit.impl;

/// Equivalent to System.Runtime.Assembly.
public struct Assembly
{
public:
final:
    BaseDomain* m_baseDomain;
    /// Pointer to the struct loader responsible for loading types from this assembly.
    ClassLoader* m_classLoader;
    /// Pointer to the MethodDesc of the assembly's entrypoint, if available.
    // Entrypoint is the method that is executed first when running the assembly.
    MethodDesc* m_entryPoint;
    /// Module(s) owned by this assembly.
    Module* m_ceemodule;
    /// PE representation of this assembly.
    PEAssembly* m_peAssembly;
    // Friend assemblies, if applicable.
    /// Any friend assemblies associated with the assembly are able to access internal members and types.
    FriendAssemblyDescriptor* m_friendAssemblyDescriptor;
    /// Indicates whether this assembly is dynamically generated (e.g., at runtime).
    bool m_isDynamic;
    /// Indicates whether or not this assembly can be collected (unloaded) if none of the types are being used.
    static if (COLLECTIBLE_TYPES)
    {
        bool m_isCollectible;
    }
    /// Pointer to the loader allocator responsible for allocating memory for this assembly.
    LoaderAllocator* m_allocator;
    /// If a TypeLib is ever required for this module, cache the pointer here.
    // Interop Type Library
    static if (COM_INTEROP)
    {
        ubyte* m_itypeLib;
        uint m_interopAttribStatus;
    }
    DebuggerAssemblyControlFlags m_debuggerFlags;
    /// Indicates whether this assembly has been terminated or unloaded.
    bool m_isTerminated;

    mixin accessors;
}

public struct FriendAssemblyDescriptor
{
public:
final:
    // Friend assemblies which have access to all internals
    ArrayList m_fullAccessFriendAssemblies;
    // Subject assemblies which we will not perform access checks against
    ArrayList m_subjectAssemblies;
    int m_refCount;

    mixin accessors;
}