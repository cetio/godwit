module vm.clsload;

import vm.assembly;
import vm.crst;

public struct ClassLoader
{
public:
    // -----> PendingTypeLoadTable* <-----
    // Classes for which load is in progress
    ubyte* unresolvedClassHash;
    CrstExplicitInit unresolvedClassLock;
    // Protects addition of elements to module's m_pAvailableClasses.
    // (indeed thus protects addition of elements to any m_pAvailableClasses in any
    // of the modules managed by this loader)
    CrstExplicitInit availableClassLock;
    CrstExplicitInit availableTypesLock;
    // Do we have any modules which need to have their classes added to
    // the available list?
    int unhashedModules;
    // Reference to the assembly this belongs to
    Assembly* assembly;
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
}