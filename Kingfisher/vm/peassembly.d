module vm.peassembly;

import vm.peimage;
import vm.assemblybinder;
import binder.assembly;

public struct PEAssembly
{
public:
    // IL image, NULL if dynamic
    PEImage* peImage;
    // This flag is not updated atomically with m_pMDImport. Its fine for debugger usage
    // but don't rely on it in the runtime. In runtime try QI'ing the m_pMDImport for
    // IID_IMDInternalImportENC
    bool mdImportIsRWDBGUseOnly;
    union
    {
        ubyte* mdImport;
        // NB: m_pMDImport_UseAccessor appears to be never assigned a value, but its purpose is just
        //     to be a placeholder that has the same type and offset as m_pMDImport.
        //
        //     The field has a different name so it would be an error to use directly.
        //     Only GetMDInternalRWAddress is supposed to use it via (TADDR)m_pMDImport_UseAccessor,
        //     which at that point will match the m_pMDImport on the debuggee side.
        //     See more scary comments in GetMDInternalRWAddress.
        ubyte* mdImportUseAccessor;
    };
    // IMetaDataImport2
    ubyte* importer;
    // IMetaDataEmit
    ubyte* emitter;
    uint refCount;
    bool isSystem;
    BinderSpace* hostAssembly;
    // For certain assemblies, we do not have m_pHostAssembly since they are not bound using an actual binder.
    // An example is Ref-Emitted assemblies. Thus, when such assemblies trigger load of their dependencies,
    // we need to ensure they are loaded in appropriate load context.
    //
    // To enable this, we maintain a concept of "FallbackBinder", which will be set to the Binder of the
    // assembly that created the dynamic assembly. If the creator assembly is dynamic itself, then its fallback
    // load context would be propagated to the assembly being dynamically generated.
    AssemblyBinder* fallbackBinder;
}