module godwit.assemblyspec;

import godwit.hash;
import godwit.loaderheap;
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