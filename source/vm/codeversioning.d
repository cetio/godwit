module godwit.codeversioning;

import godwit.method;
import godwit.collections.state;

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
    }

    StorageKind m_storageKind;
    union
    {
        NativeCodeVersionNode* m_versionNode;
        MethodDesc* m_methodDesc;
    }

    mixin accessors;
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
    }

    void* m_nativeCode;
    MethodDesc* m_methodDesc;
    long m_parentId;
    NativeCodeVersionNode* m_next;
    uint m_nativeCodeVersionId;
    //#ifdef FEATURE_TIERED_COMPILATION
    OptimizationTier m_optTier;
    /*
#ifdef HAVE_GCCOVER
    PTR_GCCoverageInfo m_gcCover;
#endif

#ifdef FEATURE_ON_STACK_REPLACEMENT
    PTR_PatchpointInfo m_patchpointInfo;
    unsigned m_ilOffset;
#endif
    */
    mixin accessors;
}