module godwit.formats.pe.directories;

public struct ExportTable
{
public:
final:
    uint flags;
    uint timeStamp;
    ushort majorVersion;
    ushort minorVersion;
    uint nameRVA;
    uint ordinalBase;
    uint numAddresses;
    uint numNames;
    uint addressTableRVA;
    uint namePointerRVA;
    uint ordinalTableRVA;
}

public struct ImportTable
{
public:
final:
    uint importLookupTableRVA;
    uint timeStamp;
    uint forwarderChain;
    uint nameRVA;
    uint importAddressTableRVA;
}

public struct ResourceTable
{
public:
final:
    ushort characteristics;
    ushort timeDateStamp;
    ushort majorVersion;
    ushort minorVersion;
    ushort numberOfNameEntries;
    ushort numberOfIDEntries;
}

public struct AttributeCertificateEntry 
{
public:
final:
    uint dwLength;
    ushort wRevision;
    ushort wCertificateType;
    ubyte[] bCertificate;
}

public struct RelocEntry
{
public:
final:
    ushort type;
    ushort offset;
}

public struct RelocTable 
{
public:
final:
    uint pageRVA;
    RelocEntry[] entries;
}