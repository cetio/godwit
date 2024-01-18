module godwit.backend.vm.readytoruninfo;

import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.readytorun;
import godwit.backend.vm.crst;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.nativeimage;
import godwit.backend.vm.hash;
import godwit.backend.vm.inlinetracking;
import caiman.traits;

public struct ReadyToRunCoreInfo
{
public:
final:
    PEImageLayout* m_layout;
    ReadyToRunCoreHeader* m_coreHeader;
    bool m_forbidLoadILBodyFixups;

    mixin accessors;
}

public struct ReadyToRunInfo
{
public:
final:
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
    /// ----> MISSING STUFF <----
    Crst m_crst;
    HashMap* m_entrypointToMethodDescMap;
    PersistentInlineTrackingMapR2R* m_persistentInlineTrackingMap;
    PersistentInlineTrackingMapR2R* m_crossModulePersistentInlineTrackingMap;
    ReadyToRunInfo* m_nextR2RForUnrelatedCode;

    mixin accessors;
}