module godwit.domainassembly;

import godwit.assembly;
import godwit.appdomain;
import godwit.peassembly;
import godwit.ceeload;
import godwit.loaderallocator;
import godwit.exinfo;
import godwit.mem.state;

public struct DomainAssembly
{
public:
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

    Assembly* m_assembly;
    AppDomain* m_domain;
    PEAssembly* m_peAssembly;
    Module* m_ceemodule;
    bool m_isfCollectible;
    DomainAssembly* m_nextInALC;
    LoaderAllocator* m_allocator;
    FileLoadLevel m_fileLoadLevel;
    bool m_isfLoading;
    ptrdiff_t m_exposedModuleObject;
    ptrdiff_t m_exposedAssemblyObject;
    ExInfo* m_error;
    bool m_disableActivationCheck;
    bool m_hostAssemblyPublished;

    mixin accessors;
}