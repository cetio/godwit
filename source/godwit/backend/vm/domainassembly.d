module godwit.backend.domainassembly;

import godwit.backend.assembly;
import godwit.backend.appdomain;
import godwit.backend.peassembly;
import godwit.backend.ceeload;
import godwit.backend.loaderallocator;
import godwit.backend.exinfo;
import caiman.traits;
import godwit.backend.corhdr;
import godwit.backend.dynamicmethod;

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

    Assembly* m_assembly;
    AppDomain* m_domain;
    PEAssembly* m_peAssembly;
    Module* m_ceemodule;
    bool m_isfCollectible;
    DomainAssembly* m_nextInALC;
    LoaderAllocator* m_allocator;
    FileLoadLevel m_fileLoadLevel;
    bool m_isLoading;

    ptrdiff_t m_exposedModuleObject;
    ptrdiff_t m_exposedAssemblyObject;
    ExInfo* m_error;
    bool m_disableActivationCheck;
    bool m_hostAssemblyPublished;
    // m_pDynamicMethodTable is used by the light code generation to allow method
    // generation on the fly. They are lazily created when/if a dynamic method is requested
    // for this specific module
    DynamicMethodTable* m_dynamicMethodTable;
    DebuggerAssemblyControlFlags m_debuggerFlags;
    uint m_notifyflags;
    bool m_debuggerUnloadStarted;

    mixin accessors;
}