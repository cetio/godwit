module godwit.assemblybinder;

import std.uuid;
import godwit.applicationcontext;
import godwit.shash;
import godwit.sbuffer;
import godwit.assembly;
import caiman.traits;
import godwit.impl;

public struct AssemblyBinder
{
public:
final:
    static if (READYTORUN)
    {
        // Wrong?
        SHash!(SimpleNameToMVIDAndAssembly, uint) m_assemblySimpleNameMvidCheckHash;
    }
    ApplicationContext m_appContext;
    // A GC handle to the managed AssemblyLoadContext.
    // It is a long weak handle for collectible AssemblyLoadContexts and strong handle for non-collectible ones.
    int* m_ptrManagedAssemblyLoadContext;
    SArray!(Assembly*) m_loadedAssemblies;

    mixin accessors;
}

public struct SimpleNameToMVIDAndAssembly
{
public:
final:
    const(char*) m_simpleName;
    // When an assembly is loaded, this Mvid value will be set to the mvid of the assembly. If there are multiple assemblies
    // with different mvid's loaded with the same simple name, then the Mvid value will be set to all zeroes.
    UUID m_mvid;
    // If an assembly of this simple name is not yet loaded, but a depedency on an exact mvid is registered, then this field will
    // be filled in with the simple assembly name of the first assembly loaded with an mvid dependency.
    const(char*) m_assemblyRequirementName;
    // To disambiguate between component images of a composite image and requirements from a non-composite --inputbubble assembly, use this bool
    bool m_compositeComponent;
    
    mixin accessors;
}