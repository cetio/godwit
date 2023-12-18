module godwit.peimage;

import godwit.crst;
import godwit.sbuffer;
import godwit.peimagelayout;
import godwit.bundle;
import godwit.simplerwlock;
import godwit.state;

public struct PEImage
{
    enum
    {
        IMAGE_FLAT,
        IMAGE_LOADED,
        IMAGE_COUNT
    }

    SString m_path;
    uint m_pathHash;
    int m_refCount;
    // means this is a unique (deduped) instance.
    bool m_inHashMap;
    // If this image is located within a single-file bundle, the location within the bundle.
    // If m_bundleFileLocation is valid, it takes precedence over m_path for loading.
    BundleFileLocation m_bundleFileLocation;
    // valid handle if we tried to open the file/path and succeeded.
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
    PEImageLayout*[IMAGE_COUNT] m_layouts;
    ubyte* m_mdImport;

    mixin accessors;
}