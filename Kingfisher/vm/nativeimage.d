module vm.nativeimage;

import vm.assemblybinder;
import vm.readytoruninfo;
import vm.ceeload;
import vm.assembly;
import vm.peimagelayout;
import inc.corhdr;
import vm.crst;
import inc.shash;
import state;

public struct NativeImage
{
public:
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
    char* m_name;
    int m_index;

    mixin accessors;
}