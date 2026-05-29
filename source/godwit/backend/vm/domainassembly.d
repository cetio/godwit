module godwit.backend.vm.domainassembly;

import godwit.backend.vm.assembly;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.peassembly;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.loaderallocator;
import godwit.backend.vm.exinfo;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.dynamicmethod;

public struct DomainAssembly
{
public:
final:
    enum FileLoadLevel : uint
    {
        // These states are tracked by FileLoadLock

        // Note = This enum must match the static array fileLoadLevelName[]
        //       which contains the printable names of the enum values

        // Note that semantics here are description is the LAST step done, not what is
        // currently being done.

        Create,
        Begin,
        FindNativeImage,
        VerifyNativeImageDeps,
        Allocate,
        AddDeps,
        PreLoadLibrary,
        LoadLibrary,
        PostLoadLibrary,
        EagerFixups,
        DeliverEvents,
        LoadVTableFixups,
        // Loaded by not yet active
        Loaded,
        // Fully active (constructors run & security checked)
        Active
    }

    Assembly* assembly;
    AppDomain* domain;
    PEAssembly* peAssembly;
    Module* ceemodule;
    bool isfCollectible;
    DomainAssembly* nextInALC;
    LoaderAllocator* allocator;
    FileLoadLevel fileLoadLevel;
    bool isLoading;

    ptrdiff_t exposedModuleObject;
    ptrdiff_t exposedAssemblyObject;
    ExInfo* error;
    bool disableActivationCheck;
    bool hostAssemblyPublished;
    // dynamicMethodTable is used by the light code generation to allow method
    // generation on the fly. They are lazily created when/if a dynamic method is requested
    // for this specific module
    DynamicMethodTable* dynamicMethodTable;
    DebuggerAssemblyControlFlags debuggerFlags;
    uint notifyflags;
    bool debuggerUnloadStarted;

}