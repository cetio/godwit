/+module readers.pe.nt;

import std.stdio, std.conv;

import readers.pe.sectionheader;
import readers.pe.utils;

/// NTHeaderを読む
public NTHeader readNTHeader(File f)
{
    NTHeader header;

    f.rawRead(header.Signature);
    f.read(header.FileHeader);

    header.read_image_optional_header(f);
    return header;
}

/// NT Header
public struct NTHeader
{
public:
    enum MAGIC : ushort 
    {
        HDR32=0x10b,
        HDR64=0x20b
    }

    char[4] Signature;
    IMAGE_FILE_HEADER FileHeader;

    IMAGE_OPTIONAL_HEADER32 OptionalHeader32;
    IMAGE_OPTIONAL_HEADER64 OptionalHeader64;

    MAGIC Magic;

    /// 32bitか64bitかがあるので関数にしてる。見た目一緒だしいいよね
    IMAGE_DATA_DIRECTORY[] imageDataDirectories()
    {
        if (Magic == MAGIC.HDR32) {
            return OptionalHeader32.DataDirectory;
        }
        else {
            return OptionalHeader64.DataDirectory;
        }
    }

    ulong imageBase()
    {
        if (Magic == MAGIC.HDR32) {
            return OptionalHeader32.ImageBase;
        }
        else {
            return OptionalHeader64.ImageBase;
        }
    }

    void read_image_optional_header(File f)
    {
        auto p = f.tell;

        f.read(Magic);
        f.seek(p);

        if (Magic == MAGIC.HDR32) {
            f.read(OptionalHeader32);
        }
        else if(Magic == MAGIC.HDR64) {
            f.read(OptionalHeader64);
        }
        else {
            throw new Exception("Unknown Maigc Number: " ~ Magic.to!string);
        }
    }

}

/// ImageFileHeader structure
public struct IMAGE_FILE_HEADER
{
public:
    ushort machine;
    ushort numberOfSections;
    uint timeDateStamp;
    uint pointerToSymbolTable;
    uint numberOfSymbols;
    ushort sizeOfOptionalHeader;
    ushort characteristics;
}

public enum int IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;

public struct IMAGE_OPTIONAL_HEADER32 
{
public:
    ushort magic;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    uint baseOfData;
    uint imageBase;
    uint sectionAlignment;
    uint fileAlignment;
    ushort majorOperatingSystemVersion;
    ushort minorOperatingSystemVersion;
    ushort majorImageVersion;
    ushort minorImageVersion;
    ushort majorSubsystemVersion;
    ushort minorSubsystemVersion;
    uint win32VersionValue;
    uint sizeOfImage;
    uint sizeOfHeaders;
    uint checkSum;
    ushort subsystem;
    ushort dllCharacteristics;
    uint sizeOfStackReserve;
    uint sizeOfStackCommit;
    uint sizeOfHeapReserve;
    uint sizeOfHeapCommit;
    uint loaderFlags;
    uint numberOfRvaAndSizes;
    IMAGE_DATA_DIRECTORY[IMAGE_NUMBEROF_DIRECTORY_ENTRIES] DataDirectory;
}

struct IMAGE_OPTIONAL_HEADER64 
{
public:
    ushort magic;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    ulong imageBase;
    uint sectionAlignment;
    uint fileAlignment;
    ushort majorOperatingSystemVersion;
    ushort minorOperatingSystemVersion;
    ushort majorImageVersion;
    ushort minorImageVersion;
    ushort majorSubsystemVersion;
    ushort minorSubsystemVersion;
    uint win32VersionValue;
    uint sizeOfImage;
    uint sizeOfHeaders;
    uint checkSum;
    ushort subsystem;
    ushort dllCharacteristics;
    ulong sizeOfStackReserve;
    ulong sizeOfStackCommit;
    ulong sizeOfHeapReserve;
    ulong sizeOfHeapCommit;
    uint loaderFlags;
    uint numberOfRvaAndSizes;
    IMAGE_DATA_DIRECTORY[IMAGE_NUMBEROF_DIRECTORY_ENTRIES] DataDirectory;
}

struct IMAGE_DATA_DIRECTORY
{
public:
    uint virtualAddress;
    uint size;

    /// VirtualAddress のファイル上での位置を求める
    uint physicalAddr(SectionHeader[] sectionHeaders) {
        return VirtualAddress.physicalAddr(sectionHeaders);
    }
}+/