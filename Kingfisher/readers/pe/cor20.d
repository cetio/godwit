/+module readers.pe.cor20;

import std.stdio;
import readers.pe.nt;
import readers.pe.sectionheader;
import readers.pe.utils;

/**
* Read the IMAGE_COR20_HEADER from the file.
*/
public IMAGE_COR20_HEADER readCOR20Header(File file, NTHeader ntHeader, SectionHeader[] sectionHeaders)
{
    auto address = ntHeader.imageDataDirectories[14].physicalAddr(sectionHeaders);

    IMAGE_COR20_HEADER header;

    // Ensure that the file seek operation is successful.
    if (file.seek(address) == -1)
    {
        throw new Exception("Failed to seek to the IMAGE_COR20_HEADER address.");
    }

    // Ensure that the file read operation is successful.
    if (file.rawRead(header) != header.sizeof)
    {
        throw new Exception("Failed to read IMAGE_COR20_HEADER.");
    }

    return header;
}

/**
* Struct to represent the IMAGE_COR20_HEADER.
*/
public struct IMAGE_COR20_HEADER
{
public:
    uint size;
    ushort majorRuntimeVersion;
    ushort minorRuntimeVersion;
    IMAGE_DATA_DIRECTORY metaData;
    uint flags;
    union
    {
        uint entryPointToken;
        uint entryPointRVA;
    }
    IMAGE_DATA_DIRECTORY resources;
    IMAGE_DATA_DIRECTORY strongNameSignature;
    IMAGE_DATA_DIRECTORY codeManagerTable;
    IMAGE_DATA_DIRECTORY vtableFixups;
    IMAGE_DATA_DIRECTORY exportAddressTableJumps;
    IMAGE_DATA_DIRECTORY managedNativeHeader;
}+/