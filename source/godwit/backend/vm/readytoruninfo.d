module godwit.backend.vm.readytoruninfo;

import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.readytorun;
import godwit.backend.vm.crst;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.nativeimage;
import godwit.backend.vm.hash;
import godwit.backend.vm.inlinetracking;

public struct ReadyToRunCoreInfo
{
public:
final:
    PEImageLayout* layout;
    ReadyToRunCoreHeader* coreHeader;
    bool forbidLoadILBodyFixups;

}

public struct ReadyToRunInfo
{
public:
final:
    Module* ceemodule;
    ModuleBase* nativeManifestModule;
    ReadyToRunHeader* header;
    bool isComponentAssembly;
    NativeImage* nativeImage;
    ReadyToRunInfo* compositeInfo;
    ReadyToRunCoreInfo component;
    ReadyToRunCoreInfo* composite;
    RuntimeFunction* runtimeFunctions;
    uint numRuntimeFunctions;
    uint* hotColdMap;
    uint numHotColdMap;
    ImageDataDirectory* sectionDelayLoadMethodCallThunks;
    ReadyToRunImportSection* importSections;
    uint numImportSections;
    bool readyToRunCodeDisabled;
    /// ----> MISSING STUFF <----
    Crst crst;
    HashMap* entrypointToMethodDescMap;
    PersistentInlineTrackingMapR2R* persistentInlineTrackingMap;
    PersistentInlineTrackingMapR2R* crossModulePersistentInlineTrackingMap;
    ReadyToRunInfo* nextR2RForUnrelatedCode;

}