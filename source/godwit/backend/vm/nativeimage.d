module godwit.backend.vm.nativeimage;

import godwit.backend.vm.assemblybinder;
import godwit.backend.vm.readytoruninfo;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.assembly;
import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.crst;
import godwit.backend.inc.shash;

public struct NativeImage
{
public:
final:
    /// Points to the OwnerCompositeExecutable section content within the component MSIL module
    const(char)* fileName;
    AssemblyBinder* assemblyBinder;
    ReadyToRunInfo* readyToRunInfo;
    // ----> IMDInternalImport <----
    void* manifestMetadata;
    PEImageLayout* imageLayout;
    Assembly** nativeMetadataAssemblyRefMap;
    ModuleBase* nativeManifestModule;
    ImageDataDirectory* componentAssemblies;
    uint componentAssemblyCount;
    uint manifestAssemblyCount;
    //SHash!(AssemblyNameIndexHashTraits, uint) assemblySimpleNameToIndexMap;
    Crst eagerFixupsLock;
    bool eagerFixupsHaveRun;
    bool readyToRunCodeDisabled;

}

/* public struct AssemblyNameIndexHashTraits
{
public:
final:
    static const bool noThrow

} */