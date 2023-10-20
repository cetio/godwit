module vm.nativeimage;

import vm.assemblybinder;
import vm.readytoruninfo;
import vm.ceeload;
import vm.assembly;
import vm.peimagelayout;
import inc.corhdr;
import vm.crst;
import inc.shash;

public struct NativeImage
{
public:
    // Points to the OwnerCompositeExecutable section content within the component MSIL module
    char* fileName;
    AssemblyBinder* assemblyBinder;
    ReadyToRunInfo* readyToRunInfo;
    void* manifestMetadata;
    PEImageLayout* imageLayout;
    Assembly** nativeMetadataAssemblyRefMap;
    ModuleBase* nativeManifestModule;
    ImageDataDirectory* componentAssemblies;
    uint componentAssemblyCount;
    uint manifestAssemblyCount;
    SHash!(AssemblyNameIndex, uint) assemblySimpleNameToIndexMap;
    Crst eagerFixupsLock;
    bool eagerFixupsHaveRun;
    bool readyToRunCodeDisabled;
}

struct AssemblyNameIndex
{
public:
    char* name;
    int index;
};