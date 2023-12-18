module vm.peimagelayout;

import vm.peimage;
import inc.corhdr;
import state;

public struct PEImageLayout
{
public:
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
    void** m_fileView;
    ptrdiff_t* m_fileMap;

    mixin accessors;
}

public struct ConvertedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
    RuntimeFunction* m_exceptionDir;
    size_t[16] m_imageParts;

    mixin accessors;
}

public struct LoadedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
    ptrdiff_t* m_hmodule;
    void** m_loadedFile;

    mixin accessors;
}