module vm.peimagelayout;

import vm.peimage;
import inc.corhdr;

public struct PEImageLayout
{
public:
    enum ImageKind
    {
        LAYOUT_FLAT   = 2,
        LAYOUT_LOADED = 4,
        LAYOUT_ANY = 0xf
    };

    int refCount;
    PEImage* owner;
}

public struct FlatImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
    void** fileView;
    ptrdiff_t* fileMap;
}

public struct ConvertedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
    RuntimeFunction* exceptionDir;
    size_t[16] imageParts;
}

public struct LoadedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
    ptrdiff_t* hmodule;
    void** loadedFile;
}