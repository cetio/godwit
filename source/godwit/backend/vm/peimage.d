module godwit.backend.vm.peimage;

import godwit.backend.vm.crst;
import godwit.backend.inc.sbuffer;
import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.bundle;
import godwit.backend.simplerwlock;
import caiman.traits;

public struct PEImage
{
public:
final:
    SString m_path;
    uint m_pathHash;
    int m_refCount;
    /// Means this is a unique (deduped) instance.
    bool m_inHashMap;
    /// If this image is located within a single-file bundle, the location within the bundle. \
    /// If m_bundleFileLocation is valid, it takes precedence over m_path for loading.
    BundleFileLocation m_bundleFileLocation;
    /// Valid handle if we tried to open the file/path and succeeded.
    ptrdiff_t m_fileHandle;
    uint m_peKind;
    uint m_machine;
    // This variable will have the data of module name.
    // It is only used by DAC to remap fusion loaded modules back to
    // disk IL. This really is a workaround. The real fix is for fusion loader
    // hook (public API on hosting) to take an additional file name hint.
    // We are piggy backing on the fact that module name is the same as file name!!!
    SString m_moduleFileNameHintUsedByDac; // This is only used by DAC
    SimpleRWLock* m_layoutLock;
    // IMAGE_COUNT
    PEImageLayout*[3] m_layouts;
    // ----> IMDInternalImport* <----
    ubyte* m_mdImport;

    mixin accessors;
}