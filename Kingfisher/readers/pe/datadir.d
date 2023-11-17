module readers.pe.datadir;

public struct DataDirectory 
{
public:
  uint virtualAddress;
  uint size; 
}

public struct DataDirectories
{
public:
    DataDirectory exportTable;
    DataDirectory importTable;
    DataDirectory resourceTable;
    DataDirectory exceptionTable;
    DataDirectory certificateTable;
    DataDirectory relocationTable;
    DataDirectory debug;
    DataDirectory architectureData;
    uint globalPtr;
    uint pad;
    DataDirectory tlsTable;
    DataDirectory loadConfigTable;
    DataDirectory boundImportTable;
    DataDirectory importAddressTable;
    DataDirectory delayImportDesc;
    DataDirectory clrRtHeader;
    ulong pad;
}