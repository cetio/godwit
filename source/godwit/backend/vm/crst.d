module godwit.backend.vm.crst;

import caiman.traits;
import godwit.impl;

public struct CrstBase
{
public:
final:
    @flags enum ReservedFlags : uint
    {
        ReservedFlagsMask = 0xC0000000,
        kInitialized = 0x80000000,
        kOSCritSec = 0x40000000,
    }

    enum CrstType
    {
        CrstAppDomainCache = 0,
        CrstArgBasedStubCache = 1,
        CrstAssemblyList = 2,
        CrstAssemblyLoader = 3,
        CrstAvailableClass = 4,
        CrstAvailableParamTypes = 5,
        CrstBaseDomain = 6,
        CrstCCompRC = 7,
        CrstClassFactInfoHash = 8,
        CrstClassInit = 9,
        CrstClrNotification = 10,
        CrstCodeFragmentHeap = 11,
        CrstCodeVersioning = 12,
        CrstCOMCallWrapper = 13,
        CrstCOMWrapperCache = 14,
        CrstDataTest1 = 15,
        CrstDataTest2 = 16,
        CrstDbgTransport = 17,
        CrstDeadlockDetection = 18,
        CrstDebuggerController = 19,
        CrstDebuggerFavorLock = 20,
        CrstDebuggerHeapExecMemLock = 21,
        CrstDebuggerHeapLock = 22,
        CrstDebuggerJitInfo = 23,
        CrstDebuggerMutex = 24,
        CrstDelegateToFPtrHash = 25,
        CrstDomainLocalBlock = 26,
        CrstDynamicIL = 27,
        CrstDynamicMT = 28,
        CrstEtwTypeLogHash = 29,
        CrstEventPipe = 30,
        CrstEventStore = 31,
        CrstException = 32,
        CrstExecutableAllocatorLock = 33,
        CrstExecuteManRangeLock = 34,
        CrstFCall = 35,
        CrstFrozenObjectHeap = 36,
        CrstFuncPtrStubs = 37,
        CrstFusionAppCtx = 38,
        CrstGCCover = 39,
        CrstGlobalStrLiteralMap = 40,
        CrstHandleTable = 41,
        CrstIbcProfile = 42,
        CrstIJWFixupData = 43,
        CrstIJWHash = 44,
        CrstILStubGen = 45,
        CrstInlineTrackingMap = 46,
        CrstInstMethodHashTable = 47,
        CrstInterop = 48,
        CrstInteropData = 49,
        CrstIsJMCMethod = 50,
        CrstISymUnmanagedReader = 51,
        CrstJit = 52,
        CrstJitGenericHandleCache = 53,
        CrstJitInlineTrackingMap = 54,
        CrstJitPatchpoint = 55,
        CrstJitPerf = 56,
        CrstJumpStubCache = 57,
        CrstLeafLock = 58,
        CrstListLock = 59,
        CrstLoaderAllocator = 60,
        CrstLoaderAllocatorReferences = 61,
        CrstLoaderHeap = 62,
        CrstManagedObjectWrapperMap = 63,
        CrstMethodDescBackpatchInfoTracker = 64,
        CrstMethodTableExposedObject = 65,
        CrstModule = 66,
        CrstModuleFixup = 67,
        CrstModuleLookupTable = 68,
        CrstMulticoreJitHash = 69,
        CrstMulticoreJitManager = 70,
        CrstNativeImageEagerFixups = 71,
        CrstNativeImageLoad = 72,
        CrstNls = 73,
        CrstNotifyGdb = 74,
        CrstObjectList = 75,
        CrstPEImage = 76,
        CrstPendingTypeLoadEntry = 77,
        CrstPerfMap = 78,
        CrstPgoData = 79,
        CrstPinnedByrefValidation = 80,
        CrstPinnedHeapHandleTable = 81,
        CrstProfilerGCRefDataFreeList = 82,
        CrstProfilingAPIStatus = 83,
        CrstRCWCache = 84,
        CrstRCWCleanupList = 85,
        CrstReadyToRunEntryPointToMethodDescMap = 86,
        CrstReflection = 87,
        CrstReJITGlobalRequest = 88,
        CrstRetThunkCache = 89,
        CrstSavedExceptionInfo = 90,
        CrstSaveModuleProfileData = 91,
        CrstSecurityStackwalkCache = 92,
        CrstSigConvert = 93,
        CrstSingleUseLock = 94,
        CrstSpecialStatics = 95,
        CrstStackSampler = 96,
        CrstStaticBoxInit = 97,
        CrstStressLog = 98,
        CrstStubCache = 99,
        CrstStubDispatchCache = 100,
        CrstStubUnwindInfoHeapSegments = 101,
        CrstSyncBlockCache = 102,
        CrstSyncHashLock = 103,
        CrstSystemBaseDomain = 104,
        CrstSystemDomain = 105,
        CrstSystemDomainDelayedUnloadList = 106,
        CrstThreadIdDispenser = 107,
        CrstThreadStore = 108,
        CrstTieredCompilation = 109,
        CrstTypeEquivalenceMap = 110,
        CrstTypeIDMap = 111,
        CrstUMEntryThunkCache = 112,
        CrstUMEntryThunkFreeListLock = 113,
        CrstUniqueStack = 114,
        CrstUnresolvedClassLock = 115,
        CrstUnwindInfoTableLock = 116,
        CrstVSDIndirectionCellLock = 117,
        CrstWrapperTemplate = 118,
        kNumberOfCrstTypes = 119
    }

    // ReservedFlags only represents the base required flags,
    // This can contain more than ReservedFlags.
    ReservedFlags m_flags;
    static if (DEBUG)
    {
        uint m_numEnters;
        CrstType m_crstType;
        const(char)* m_tag;
        int m_crstLevel;
        EEThreadId m_holderThreadId;
        CrstBase* m_next;
        CrstBase* m_prev;
        int m_cannotLeave;
        uint m_numNoTriggerGC;
    }
    mixin accessors;
}

public struct Crst
{
    CrstBase crstBase;
    alias crstBase this;
}

public struct CrstStatic
{
    CrstBase crstBase;
    alias crstBase this;
}

public struct CrstExplicitInit
{
    CrstStatic crstStatic;
    alias crstStatic this;
}