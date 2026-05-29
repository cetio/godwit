module godwit.backend.vm.clsload;

import godwit.backend.vm.assembly;
import godwit.backend.vm.crst;
import godwit.backend.vm.pendingload;
import godwit.impl;

public struct ClassLoader
{
public:
final:
    // Classes for which load is in progress
    PendingTypeLoadTable* unresolvedClassHash;
    CrstExplicitInit unresolvedClassLock;
    // Protects addition of elements to module's availableClasses.
    // (indeed thus protects addition of elements to any availableClasses in any
    // of the modules managed by this loader)
    CrstExplicitInit availableClassLock;
    CrstExplicitInit availableTypesLock;
    // Do we have any modules which need to have their classes added to
    // the available list?
    int unhashedModules;
    // Reference to the assembly this belongs to
    Assembly* assembly;
    static if (DEBUG)
    {
        uint numDebugMethods;
        uint numDebugFieldDescs;
        uint numDebugClasses;
        uint numDebugDuplicateInterfaceSlots;
        uint numGCSize;
        uint numInterfaceMapSize;
        uint numMethodTableSize;
        uint numVtableData;
        uint numStaticFieldData;
        uint numFieldDescData;
        uint numMethodDescData;
        size_t numEEClassData;
    }

}