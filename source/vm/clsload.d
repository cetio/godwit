module godwit.clsload;

import godwit.assembly;
import godwit.crst;
import godwit.pendingload;
import godwit.collections.state;

public struct ClassLoader
{
public:
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
    /*
#ifdef _DEBUG
    DWORD               m_dwDebugMethods;
    DWORD               m_dwDebugFieldDescs; // Doesn't include anything we don't allocate a FieldDesc for
    DWORD               m_dwDebugClasses;
    DWORD               m_dwDebugDuplicateInterfaceSlots;
    DWORD               m_dwGCSize;
    DWORD               m_dwInterfaceMapSize;
    DWORD               m_dwMethodTableSize;
    DWORD               m_dwVtableData;
    DWORD               m_dwStaticFieldData;
    DWORD               m_dwFieldDescData;
    DWORD               m_dwMethodDescData;
    size_t              m_dwEEClassData;
#endif
    */
    mixin accessors;
}