module vm.peimage;

import vm.crst;
import inc.sbuffer;
import vm.peimagelayout;
import inc.bundle;

public struct PEImage
{
    enum
    {
        IMAGE_FLAT,
        IMAGE_LOADED,
        IMAGE_COUNT
    };

    SString path;
    uint pathHash;
    int refCount;
    // means this is a unique (deduped) instance.
    bool inHashMap;
    // If this image is located within a single-file bundle, the location within the bundle.
    // If m_bundleFileLocation is valid, it takes precedence over m_path for loading.
    BundleFileLocation bundleFileLocation;
    // valid handle if we tried to open the file/path and succeeded.
    ptrdiff_t fileHandle;
    uint peKind;
    uint machine;
    // This variable will have the data of module name.
    // It is only used by DAC to remap fusion loaded modules back to
    // disk IL. This really is a workaround. The real fix is for fusion loader
    // hook (public API on hosting) to take an additional file name hint.
    // We are piggy backing on the fact that module name is the same as file name!!!
    SString   moduleFileNameHintUsedByDac; // This is only used by DAC
    // -----> SimpleRWLock* <-----
    void* layoutLock;
    PEImageLayout*[IMAGE_COUNT] layouts;
    // -----> IMDInternalImport* <-----
    ubyte* mdImport;
}