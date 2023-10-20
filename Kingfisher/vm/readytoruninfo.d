module vm.readytoruninfo;

import vm.peimagelayout;
import inc.readytorun;
import vm.crst;
import inc.corhdr;
import vm.ceeload;
import vm.nativeimage;
import vm.hash;
import vm.inlinetracking;

public struct ReadyToRunCoreInfo
{
public:
    PEImageLayout* layout;
    ReadyToRunCoreHeader* coreHeader;
    bool forbidLoadILBodyFixups;
}

public struct ReadyToRunInfo
{
public:
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
    Crst crst;
    HashMap* entrypointToMethodDescMap;
    PersistentInlineTrackingMapR2R* persistentInlineTrackingMap;
    PersistentInlineTrackingMapR2R* crossModulePersistentInlineTrackingMap;
    ReadyToRunInfo* nextR2RForUnrelatedCode;
}