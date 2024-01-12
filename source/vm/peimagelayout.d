module godwit.peimagelayout;

import godwit.peimage;
import godwit.corhdr;
import godwit.llv.traits;

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

    mixin accessors;
}

public struct FlatImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    void** m_fileView;
    ptrdiff_t* m_fileMap;

    mixin accessors;
}

public struct ConvertedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    RuntimeFunction* m_exceptionDir;
    size_t[16] m_imageParts;

    mixin accessors;
}

public struct LoadedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    ptrdiff_t* m_hmodule;
    void** m_loadedFile;

    mixin accessors;
}