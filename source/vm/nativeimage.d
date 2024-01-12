module godwit.nativeimage;

import godwit.assemblybinder;
import godwit.readytoruninfo;
import godwit.ceeload;
import godwit.assembly;
import godwit.peimagelayout;
import godwit.corhdr;
import godwit.crst;
import godwit.shash;
import godwit.llv.traits;

public struct NativeImage
{
public:
final:
    // Points to the OwnerCompositeExecutable section content within the component MSIL module
    char* m_fileName;
    AssemblyBinder* m_assemblyBinder;
    ReadyToRunInfo* m_readyToRunInfo;
    void* m_manifestMetadata;
    PEImageLayout* m_imageLayout;
    Assembly** m_nativeMetadataAssemblyRefMap;
    ModuleBase* m_nativeManifestModule;
    ImageDataDirectory* m_componentAssemblies;
    uint m_componentAssemblyCount;
    uint m_manifestAssemblyCount;
    SHash!(AssemblyNameIndex, uint) m_assemblySimpleNameToIndexMap;
    Crst m_eagerFixupsLock;
    bool m_eagerFixupsHaveRun;
    bool m_readyToRunCodeDisabled;

    mixin accessors;
}

public struct AssemblyNameIndex
{
public:
final:
    char* m_name;
    int m_index;

    mixin accessors;
}