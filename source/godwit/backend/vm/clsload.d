module godwit.backend.vm.clsload;

import godwit.backend.vm.assembly;
import godwit.backend.vm.crst;
import godwit.backend.vm.pendingload;
import caiman.traits;
import godwit.impl;

public struct ClassLoader
{
public:
final:
    // Classes for which load is in progress
    PendingTypeLoadTable* m_unresolvedClassHash;
    CrstExplicitInit m_unresolvedClassLock;
    // Protects addition of elements to module's m_pAvailableClasses.
    // (indeed thus protects addition of elements to any m_pAvailableClasses in any
    // of the modules managed by this loader)
    CrstExplicitInit m_availableClassLock;
    CrstExplicitInit m_availableTypesLock;
    // Do we have any modules which need to have their classes added to
    // the available list?
    int m_unhashedModules;
    // Reference to the assembly this belongs to
    Assembly* m_assembly;
    static if (DEBUG)
    {
        uint m_numDebugMethods;
        uint m_numDebugFieldDescs;
        uint m_numDebugClasses;
        uint m_numDebugDuplicateInterfaceSlots;
        uint m_numGCSize;
        uint m_numInterfaceMapSize;
        uint m_numMethodTableSize;
        uint m_numVtableData;
        uint m_numStaticFieldData;
        uint m_numFieldDescData;
        uint m_numMethodDescData;
        size_t m_numEEClassData;
    }
    
    mixin accessors;
}