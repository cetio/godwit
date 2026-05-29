module godwit.backend.vm.codeversion;

import godwit.backend.vm.method;
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
        MethodDesc* methodDesc;
    }
    StorageKind storageKind;
    union
    {
        NativeCodeVersionNode* versionNode;
        MethodDesc* syntheticMethodDesc;
    }

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

    void* nativeCode;
    MethodDesc* methodDesc;
    long parentId;
    NativeCodeVersionNode* next;
    uint nativeCodeVersionId;
    static if (TIERED_COMPILATION)
    {
        OptimizationTier optTier;
    }
    static if (GCCOVER)
    {
        // ----> GCCoverageInfo <----
        uint* gcCover;
    }
    static if (ON_STACK_REPLACEMENT)
    {
        // ----> PatchpointInfo <----
        uint* patchpointInfo;
        uint ilOffset;
    }
    uint isActiveChild;

}