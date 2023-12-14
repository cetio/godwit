module readers.pe.optional;

import std.typecons;

public enum ImageType : ushort
{
    ROM = 0x107,
    PE32 = 0x10b,
    PE32Plus = 0x20b
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
    // magic
    ImageType type;
    ubyte majorLinkerVersion;
    ubyte minorLinkerVersion;
    uint sizeOfCode;
    uint sizeOfInitializedData;
    uint sizeOfUninitializedData;
    uint addressOfEntryPoint;
    uint baseOfCode;
    Nullable!uint baseOfData;
    // Everything past this will be null if sizeOfOptionalHeader == 0 or type == ImageType.ROM
    // Assumes that this image is ImageType.PE32Plus.
    Nullable!ubyte* imageBase;
    Nullable!uint sectionAlignment;
    Nullable!uint fileAlignment;
    Nullable!ushort majorOSVersion;
    Nullable!ushort minorOSVersion;
    Nullable!ushort majorImageVersion;
    Nullable!ushort minorImageVersion;
    Nullable!ushort majorSubsystemVersion;
    Nullable!ushort minorSubsystemVersion;
    Nullable!uint win32Version;
    Nullable!uint sizeOfImage;
    Nullable!uint sizeOfHeaders;
    Nullable!uint checksum;
    Nullable!Subsystem subsystem;
    Nullable!DllCharacteristics dllCharacteristics;
    Nullable!ulong sizeOfStackReserve;
    Nullable!ulong sizeOfStackCommit;
    Nullable!ulong sizeOfHeapReserve;
    Nullable!ulong sizeOfHeapCommit;
    Nullable!uint loaderFlags;
    Nullable!uint numDataDirectories;
}

public struct DataDirectory
{
public:
    uint rva;
    uint size;
}