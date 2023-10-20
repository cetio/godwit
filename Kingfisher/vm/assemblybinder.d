module vm.assemblybinder;

import std.uuid;
import binder.applicationcontext;
import inc.shash;
import inc.sbuffer;
import vm.assembly;

public struct AssemblyBinder
{
public:
    // #ifdef FEATURE_READYTORUN
    SHash!(SimpleNameToMVIDAndAssembly, uint) assemblySimpleNameMvidCheckHash;
    ApplicationContext appContext;
    // A GC handle to the managed AssemblyLoadContext.
    // It is a long weak handle for collectible AssemblyLoadContexts and strong handle for non-collectible ones.
    int* ptrManagedAssemblyLoadContext;
    SArray!Assembly* loadedAssemblies;
}

public struct SimpleNameToMVIDAndAssembly
{
public:
    char* simpleName;
    // When an assembly is loaded, this Mvid value will be set to the mvid of the assembly. If there are multiple assemblies
    // with different mvid's loaded with the same simple name, then the Mvid value will be set to all zeroes.
    UUID mvid;
    // If an assembly of this simple name is not yet loaded, but a depedency on an exact mvid is registered, then this field will
    // be filled in with the simple assembly name of the first assembly loaded with an mvid dependency.
    char* assemblyRequirementName;
    // To disambiguate between component images of a composite image and requirements from a non-composite --inputbubble assembly, use this bool
    bool compositeComponent;
}