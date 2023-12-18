module vm.readytoruninfo;

import vm.peimagelayout;
import inc.readytorun;
import vm.crst;
import inc.corhdr;
import vm.ceeload;
import vm.nativeimage;
import vm.hash;
import vm.inlinetracking;
import state;

public struct ReadyToRunCoreInfo
{
public:
    PEImageLayout* m_layout;
    ReadyToRunCoreHeader* m_coreHeader;
    bool m_forbidLoadILBodyFixups;

    mixin accessors;
}

public struct ReadyToRunInfo
{
public:
    Module* m_ceemodule;
    ModuleBase* m_nativeManifestModule;
    ReadyToRunHeader* m_header;
    bool m_isComponentAssembly;
    NativeImage* m_nativeImage;
    ReadyToRunInfo* m_compositeInfo;
    ReadyToRunCoreInfo m_component;
    ReadyToRunCoreInfo* m_composite;
    RuntimeFunction* m_runtimeFunctions;
    uint m_numRuntimeFunctions;
    uint* m_hotColdMap;
    uint m_numHotColdMap;
    ImageDataDirectory* m_sectionDelayLoadMethodCallThunks;
    ReadyToRunImportSection* m_importSections;
    uint m_numImportSections;
    bool m_readyToRunCodeDisabled;
    Crst m_crst;
    HashMap* m_entrypointToMethodDescMap;
    PersistentInlineTrackingMapR2R* m_persistentInlineTrackingMap;
    PersistentInlineTrackingMapR2R* m_crossModulePersistentInlineTrackingMap;
    ReadyToRunInfo* m_nextR2RForUnrelatedCode;

    mixin accessors;
}