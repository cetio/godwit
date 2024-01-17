module godwit.codeversion;

import godwit.method;
import caiman.traits;
import godwit.impl;

public struct NativeCodeVersion
{
public:
final:
    enum StorageKind
    {
        Unknown,
        Explicit,
        Synthetic
    }

    static if (CODE_VERSIONING)
    {
        MethodDesc* m_methodDesc;
    }
    StorageKind m_storageKind;
    union
    {
        NativeCodeVersionNode* m_versionNode;
        MethodDesc* m_syntheticMethodDesc;
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
    static if (TIERED_COMPILATION)
    {
        OptimizationTier m_optTier;
    }
    static if (GCCOVER)
    {
        // ----> GCCoverageInfo <----
        uint* m_gcCover;
    }
    static if (ON_STACK_REPLACEMENT)
    {
        // ----> PatchpointInfo <----
        uint* m_patchpointInfo;
        uint m_ilOffset;
    }
    uint m_isActiveChild;

    mixin accessors;
}