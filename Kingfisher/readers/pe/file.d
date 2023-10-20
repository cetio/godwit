/++module readers.pe.file;

import std.stdio;
import readers.pe.utils;
import readers.pe.msdos;
import readers.pe.nt;
import readers.pe.sectionheader;
import readers.pe.cor20;
import readers.pe.resourcessection;
import readers.pe.streamheader;
import readers.pe.metadata;
import readers.pe.tildastream;
import readers.pe.manifestresource;

/**
* Struct to represent a processed PE file.
*/
public struct PEFile
{
public:
    DOSHeader dosHeader;
    NTHeader ntHeader;
    SectionHeader[] sectionHeaders;
    IMAGE_COR20_HEADER cor20;
    MetaData metaData;
    StreamHeader[] streamHeaders;
    TildaStream tildaStream;
    ManifestResource[] manifestResources;
    Resource[] resources;
}

/**
* Read and process a PE file to extract relevant information.
*/
public PEFile readPE(File f)
{
    PEFile pe;

    with (pe)
    {
        dosHeader = readDOSHeader(f);

        // Read NT header and other necessary data
        f.seek(dosHeader.e_lfanew);
        ntHeader = readNTHeader(f);
        sectionHeaders = readSectionHeaders(f, ntHeader.FileHeader.numberOfSections);
        cor20 = readCOR20HEADER(f, ntHeader, sectionHeaders);

        // Read metadata
        f.seek(cor20.MetaData.physicalAddr(sectionHeaders));
        auto addr = f.tell;
        metaData = readMetaData(f);

        // Read stream headers
        streamHeaders = f.readStreamHeaders(metaData.streams);

        // Find the tildaStream header
        StreamHeader tildaStreamHeader;
        foreach (header; streamHeaders)
        {
            if (header.name[1] == '~' || header.name[1] == '-')
            {
                tildaStreamHeader = header;
            }
        }

        // Check if the tildaStream header was found
        if (tildaStreamHeader.name.length == 0)
        {
            throw new Exception("Failed to read #~ stream offset");
        }

        // Read tildaStream and other relevant data
        f.seek(addr + tildaStreamHeader.offset);
        tildaStream = f.readTildaStream;

        // Skip to ManifestResource table and read resources
        foreach (i; 0..40)
        {
            f.seek(f.tell + tildaStream.tableSize(i));
        }

        foreach (i; 0..tildaStream.rows[40])
        {
            manifestResources ~= f.readManifestResource;
        }

        // Read resource headers and resources
        foreach (res; manifestResources)
        {
            f.seek(cor20.resources.physicalAddr(sectionHeaders) + 4 + res.offset);
            auto resourcesHeader = f.readResourcesHeader;
            resources ~= f.readResources(resourcesHeader);
        }
    }

    return pe;
}+/