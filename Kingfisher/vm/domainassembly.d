module vm.domainassembly;

import vm.assembly;
import vm.appdomain;
import vm.peassembly;
import vm.ceeload;
import vm.loaderallocator;
import vm.exinfo;

public struct DomainAssembly
{
public:
    enum FileLoadLevel : uint
    {
        // These states are tracked by FileLoadLock

        // Note: This enum must match the static array fileLoadLevelName[]
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
    };

    Assembly* assembly;
    AppDomain* domain;
    PEAssembly* peAssembly;
    Module* ceemodule;
    bool isfCollectible;
    DomainAssembly* nextInALC;
    LoaderAllocator* loaderAllocator;
    FileLoadLevel fileLoadLevel;
    bool isfLoading;
    ptrdiff_t exposedModuleObject;
    ptrdiff_t exposedAssemblyObject;
    ExInfo* error;
    bool disableActivationCheck;
    bool hostAssemblyPublished;
}