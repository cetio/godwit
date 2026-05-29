module godwit.backend.vm.peimage;

import godwit.backend.vm.crst;
import godwit.backend.inc.sbuffer;
import godwit.backend.vm.peimagelayout;
import godwit.backend.inc.bundle;
import godwit.backend.simplerwlock;

public struct PEImage
{
public:
final:
    SString path;
    uint pathHash;
    int refCount;
    /// Means this is a unique (deduped) instance.
    bool inHashMap;
    /// If this image is located within a single-file bundle, the location within the bundle. \
    /// If bundleFileLocation is valid, it takes precedence over path for loading.
    BundleFileLocation bundleFileLocation;
    /// Valid handle if we tried to open the file/path and succeeded.
    ptrdiff_t fileHandle;
    uint peKind;
    uint machine;
    // This variable will have the data of module name.
    // It is only used by DAC to remap fusion loaded modules back to
    // disk IL. This really is a workaround. The real fix is for fusion loader
    // hook (public API on hosting) to take an additional file name hint.
    // We are piggy backing on the fact that module name is the same as file name!!!
    SString moduleFileNameHintUsedByDac; // This is only used by DAC
    SimpleRWLock* layoutLock;
    // IMAGE_COUNT
    PEImageLayout*[3] layouts;
    // ----> IMDInternalImport* <----
    ubyte* mdImport;

}