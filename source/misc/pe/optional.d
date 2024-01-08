module godwit.pe.optional;

import std.typecons;

public enum ImageType : ushort
{
    ROM = 0x107,
    PE32 = 0x10b,
    PE64 = 0x20b
}

public enum Subsystem : ushort
{
    Unknown = 0,
    Native = 1,
    WindowsGUI = 2,
    WindowsCUI = 3,
    Os2CUI = 5,
    PosixCUI = 7,
    NativeWindows = 8,
    WindowsCEGUI = 9,
    EFIApp = 10,
    EFIBootDriver = 11,
    EFIRuntimeDriver = 12,
    EFIROM = 13,
    Xbox = 14,
    WindowsBootApp = 16
}

public enum DllCharacteristics : ushort
{
    None = 0,
    HighEntropyVA = 0x0020,
    DynamicBase = 0x0040,
    ForceIntegrity = 0x0080,
    NXCompat = 0x0100,
    NoIsolation = 0x0200,
    NoSEH = 0x0400,
    NoBind = 0x0800,
    AppContainer = 0x1000,
    WDMDriver = 0x2000,
    GuardCF = 0x4000,
    TerminalServerAware = 0x8000
}

public struct OptionalImage
{
public:
    // All unset if sizeOfOptionalHeader == 0!
    // magic
    ImageType type;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    // PE32 only!
    uint baseOfData;
    // All below unset if type == ImageType.ROM!
    // Assumes that this image is ImageType.PE64.
    ubyte* imageBase;
    uint sectionAlignment;
    uint fileAlignment;
    ushort majorOSVersion;
    ushort minorOSVersion;
    ushort majorImageVersion;
    ushort minorImageVersion;
    ushort majorSubsystemVersion;
    ushort minorSubsystemVersion;
    uint win32Version;
    uint sizeOfImage;
    uint sizeOfHeaders;
    uint checksum;
    Subsystem subsystem;
    DllCharacteristics dllCharacteristics;
    ulong sizeOfStackReserve;
    ulong sizeOfStackCommit;
    ulong sizeOfHeapReserve;
    ulong sizeOfHeapCommit;
    uint loaderFlags;
    uint numDataDirectories;
}

public struct ROMImage
{
public:
    // magic
    ImageType type;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
}

public struct PE32Image
{
public:
    // magic
    ImageType type;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    // PE32 only!
    uint baseOfData;
    uint imageBase;
    uint sectionAlignment;
    uint fileAlignment;
    ushort majorOSVersion;
    ushort minorOSVersion;
    ushort majorImageVersion;
    ushort minorImageVersion;
    ushort majorSubsystemVersion;
    ushort minorSubsystemVersion;
    uint win32Version;
    uint sizeOfImage;
    uint sizeOfHeaders;
    uint checksum;
    Subsystem subsystem;
    DllCharacteristics dllCharacteristics;
    uint sizeOfStackReserve;
    uint sizeOfStackCommit;
    uint sizeOfHeapReserve;
    uint sizeOfHeapCommit;
    uint loaderFlags;
    uint numDataDirectories;
}

public struct PE64Image
{
public:
    // magic
    ImageType type;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    // Will be ignored!
    uint baseOfData;
    ubyte* imageBase;
    uint sectionAlignment;
    uint fileAlignment;
    ushort majorOSVersion;
    ushort minorOSVersion;
    ushort majorImageVersion;
    ushort minorImageVersion;
    ushort majorSubsystemVersion;
    ushort minorSubsystemVersion;
    uint win32Version;
    uint sizeOfImage;
    uint sizeOfHeaders;
    uint checksum;
    Subsystem subsystem;
    DllCharacteristics dllCharacteristics;
    ulong sizeOfStackReserve;
    ulong sizeOfStackCommit;
    ulong sizeOfHeapReserve;
    ulong sizeOfHeapCommit;
    uint loaderFlags;
    uint numDataDirectories;
}

public struct DataDirectory
{
public:
    uint rva;
    uint size;
}