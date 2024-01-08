module godwit.pe.directories;

public struct ExportTable
{
public:
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
    uint importLookupTableRVA;
    uint timeStamp;
    uint forwarderChain;
    uint nameRVA;
    uint importAddressTableRVA;
}

public struct ResourceTable
{
    ushort characteristics;
    ushort timeDateStamp;
    ushort majorVersion;
    ushort minorVersion;
    ushort numberOfNameEntries;
    ushort numberOfIDEntries;
}

public struct AttributeCertificateEntry 
{
    uint dwLength;
    ushort wRevision;
    ushort wCertificateType;
    ubyte[] bCertificate;
}

public struct RelocEntry
{
    ushort type;
    ushort offset;
}

public struct RelocTable 
{
    uint pageRVA;
    RelocEntry[] entries;
}