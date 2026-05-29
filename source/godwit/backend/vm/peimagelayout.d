module godwit.backend.vm.peimagelayout;

import godwit.backend.vm.peimage;
import godwit.backend.inc.corhdr;

public struct PEImageLayout
{
public:
final:
    enum ImageKind
    {
        LAYOUT_FLAT   = 2,
        LAYOUT_LOADED = 4,
        LAYOUT_ANY = 0xf
    }

    int m_refCount;
    PEImage* m_owner;

}

public struct FlatImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    void** m_fileView;
    ptrdiff_t* m_fileMap;

}

public struct ConvertedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    RuntimeFunction* m_exceptionDir;
    // MAX_PARTS
    size_t[16] m_imageParts;

}

public struct LoadedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    version (Windows)
    {
        ptrdiff_t* m_hmodule;
    }
    else
    {
        void** m_loadedFile;
    }

}