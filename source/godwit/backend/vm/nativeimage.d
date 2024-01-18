module godwit.backend.vm.nativeimage;

import godwit.backend.vm.assemblybinder;
import godwit.backend.vm.readytoruninfo;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.assembly;
import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.crst;
import godwit.backend.inc.shash;
import caiman.traits;

public struct NativeImage
{
public:
final:
    /// Points to the OwnerCompositeExecutable section content within the component MSIL module
    const(char)* m_fileName;
    AssemblyBinder* m_assemblyBinder;
    ReadyToRunInfo* m_readyToRunInfo;
    // ----> IMDInternalImport <----
    void* m_manifestMetadata;
    PEImageLayout* m_imageLayout;
    Assembly** m_nativeMetadataAssemblyRefMap;
    ModuleBase* m_nativeManifestModule;
    ImageDataDirectory* m_componentAssemblies;
    uint m_componentAssemblyCount;
    uint m_manifestAssemblyCount;
    //SHash!(AssemblyNameIndexHashTraits, uint) m_assemblySimpleNameToIndexMap;
    Crst m_eagerFixupsLock;
    bool m_eagerFixupsHaveRun;
    bool m_readyToRunCodeDisabled;

    mixin accessors;
}

/* public struct AssemblyNameIndexHashTraits
{
public:
final:
    static const bool m_noThrow

    mixin accessors;
} */