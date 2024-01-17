module godwit.backend.nativeimage;

import godwit.backend.assemblybinder;
import godwit.backend.readytoruninfo;
import godwit.backend.ceeload;
import godwit.backend.assembly;
import godwit.backend.peimagelayout;
import godwit.backend.corhdr;
import godwit.backend.crst;
import godwit.backend.shash;
import caiman.traits;

public struct NativeImage
{
public:
final:
    /// Points to the OwnerCompositeExecutable section content within the component MSIL module
    const(char*) m_fileName;
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