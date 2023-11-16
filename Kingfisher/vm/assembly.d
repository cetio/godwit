module vm.assembly;

import vm.ceeload;
import vm.method;
import vm.peassembly;
import vm.loaderallocator;
import vm.appdomain;
import vm.clsload;
import inc.arraylist;
import inc.corhdr;

// Equivalent to System.Runtime.Assembly.
public struct Assembly
{
public:
    BaseDomain* baseDomain;
    // Pointer to the struct loader responsible for loading types from this assembly.
    ClassLoader* classLoader;
    // Pointer to the MethodDesc of the assembly's entrypoint, if available.
    // Entrypoint is the method that is executed first when running the assembly.
    MethodDesc* entryPoint;
    // Module(s) owned by this assembly.
    Module* ceemodule;
    // PE representation of this assembly.
    PEAssembly* peAssembly;
    // Friend assemblies, if applicable.
    // Any friend assemblies associated with the assembly are able to access internal members and types.
    FriendAssemblyDescriptor* friendAssemblyDescriptor;
    // Indicates whether this assembly is dynamically generated (e.g., at runtime).
    bool isDynamic;
    // Indicates whether or not this assembly can be collected (unloaded) if none of the types are being used.
    //#ifdef FEATURE_COLLECTIBLE_TYPES
    bool isCollectible;
    // Pointer to the loader allocator responsible for allocating memory for this assembly.
    LoaderAllocator* loaderAllocator;
    // If a TypeLib is ever required for this module, cache the pointer here.
    // Interop Type Library
    //#ifdef FEATURE_COMINTEROP
    ubyte* itypeLib;
    uint interopAttribStatus;
    //
    DebuggerAssemblyControlFlags debuggerFlags;
    // Indicates whether this assembly has been terminated or unloaded.
    bool isTerminated;
/*
    enum IsInstrumentedStatus {
        IS_INSTRUMENTED_UNSET = 0,
        IS_INSTRUMENTED_FALSE = 1,
        IS_INSTRUMENTED_TRUE = 2,
    };
    IsInstrumentedStatus    m_isInstrumentedStatus;
#endif // FEATURE_READYTORUN
*/
}

public struct FriendAssemblyDescriptor
{
public:
    // Friend assemblies which have access to all internals
    ArrayList fullAccessFriendAssemblies;
    // Subject assemblies which we will not perform access checks against
    ArrayList subjectAssemblies;
    int refCount;
}