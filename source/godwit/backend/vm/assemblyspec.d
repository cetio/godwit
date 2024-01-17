module godwit.backend.assemblyspec;

import godwit.backend.hash;
import godwit.backend.loaderheap;
import caiman.traits;

public struct AssemblySpecBindingCache
{
public:
final:
    // PtrHashMap
    HashMap m_map;
    LoaderHeap* m_heap;

    mixin accessors;
}