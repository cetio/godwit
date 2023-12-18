module godwit.elf.header;

public enum Architecture : ubyte
{
    x32 = 1,
    x64 = 2
}

public enum Endian : ubyte
{
    Little = 1,
    Big = 2
}

public enum ABI : ubyte
{
    SystemV = 0,
    HPUX,
    NetBSD,
    Linux,
    GNUHurd,
    Solaris = 6,
    AIX,
    IRIX,
    FreeBSD,
    Tru64,
    Novell,
    OpenBSD,
    OpenVMS,
    NonstopKernel,
    AROS,
    FenixOS,
    NuxiCloudABI,
    StratusOpenVOS
}

public struct ELFHeader
{
public:
    int e_magic;
    Architecture e_class;
    Endian e_data;
    ubyte e_version;
    ABI e_osabi;
    ubyte e_abiversion;
    ubyte[7] e_pad;
    
}