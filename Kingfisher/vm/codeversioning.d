module vm.codeversioning;

import vm.method;

public struct NativeCodeVersion
{
public:
    /*
#ifndef FEATURE_CODE_VERSIONING
    PTR_MethodDesc m_pMethodDesc;
#else // FEATURE_CODE_VERSIONING
    */
    enum StorageKind
    {
        Unknown,
        Explicit,
        Synthetic
    };

    StorageKind storageKind;
    union
    {
        NativeCodeVersionNode* versionNode;
        MethodDesc* methodDesc;
    };
}

public struct NativeCodeVersionNode
{
public:
    enum OptimizationTier
    {
        Tier0,
        Tier1,
        Tier1OSR,
        // may do less optimizations than tier 1
        TierOptimized,
        Tier0Instrumented,
        Tier1Instrumented,
    };

    void* nativeCode;
    MethodDesc* methodDesc;
    long parentId;
    NativeCodeVersionNode* next;
    uint nativeCodeVersionId;
    //#ifdef FEATURE_TIERED_COMPILATION
    OptimizationTier optTier;
    /*
#ifdef HAVE_GCCOVER
    PTR_GCCoverageInfo m_gcCover;
#endif

#ifdef FEATURE_ON_STACK_REPLACEMENT
    PTR_PatchpointInfo m_patchpointInfo;
    unsigned m_ilOffset;
#endif
    */
}