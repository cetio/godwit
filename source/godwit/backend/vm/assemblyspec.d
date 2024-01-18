module godwit.backend.vm.assemblyspec;

import godwit.backend.vm.hash;
import godwit.backend.inc.loaderheap;
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