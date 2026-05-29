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

    int refCount;
    PEImage* owner;

}

public struct FlatImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    void** fileView;
    ptrdiff_t* fileMap;

}

public struct ConvertedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    RuntimeFunction* exceptionDir;
    // MAX_PARTS
    size_t[16] imageParts;

}

public struct LoadedImageLayout
{
    PEImageLayout peImageLayout;
    alias peImageLayout this;

public:
final:
    version (Windows)
    {
        ptrdiff_t* hmodule;
    }
    else
    {
        void** loadedFile;
    }

}