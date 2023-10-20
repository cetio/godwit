/+module readers.pe.resourcessection;

import std.stdio;
import std.conv;
import readers.pe.utils;

public enum RESOURCE_TYPE_LENGTH = 16; // Example value, use the correct length.
public enum RESOURCE_TYPE_PADDING = 8; // Example value, use the correct padding.

/**
* Read the ResourcesHeader from the file.
*/
public ResourcesHeader readResourcesHeader(File file)
{
    auto addr = file.tell;
    RESOURCES_SECTION resource;

    file.rawRead(resource.Signature);
    file.read(resource.ReaderCount);
    file.read(resource.ReaderTypeLength);

    resource.ReaderType.length = RESOURCE_TYPE_LENGTH; // Use the correct length.
    file.rawRead(resource.ReaderType);

    file.read(resource.Version);
    file.read(resource.ResourceCount);
    file.read(resource.ResourceTypeCount);

    foreach (i; 0..resource.ResourceTypeCount)
    {
        resource.ResourceTypes ~= file.readBlob.toChars;
    }

    // Padding
    while (true)
    {
        while (file.tell % RESOURCE_TYPE_PADDING != 0)
        {
            file.seek(file.tell + 1);
        }

        // Check for PAD characters
        {
            auto p = file.tell;
            auto c = cast(char)file.readBYTE;
            if (!(c == 'P' || c == 'A' || c == 'D'))
            {
                file.seek(p);
                break;
            }
        }
    }

    // Skipping hash data
    auto skips = uint.sizeof * resource.resourceCount;
    file.seek(file.tell + skips);

    foreach (i; 0..resource.resourceCount)
    {
        resource.resourceNameOffsets ~= file.readuint;
    }
    file.read(resource.dataSectionOffset);

    auto base = file.tell;
    ResourceInfo[] resourceInfos;

    foreach (i; 0..resource.resourceCount)
    {
        file.seek(base + resource.resourceNameOffsets[i]);

        ResourceInfo info;
        string a = (cast(wstring)file.readString).to!string;
        info.Name = a.dup;
        file.read(info.offset);

        resourceInfos ~= info;
    }

    auto physicalAddr = addr + resource.dataSectionOffset;

    return new ResourcesHeader(resource, physicalAddr, resourceInfos);
}

/**
* Read resources from the file based on the provided ResourcesHeader.
*/
public Resource[] readResources(File file, ResourcesHeader header)
{
    auto addr = header.physicalAddr;
    Resource[] resources;

    foreach (info; header.resourceInfos)
    {
        file.seek(addr + info.offset);
        auto resourceType = file.read7BitEncodedInteger; // Resource type?
        auto resourceLength = file.read7BitEncodedInteger;

        Resource res;
        res.name = info.name;
        res.value.length = cast(uint)resourceLength;
        file.rawRead(res.value);
        resources ~= res;
    }

    return resources;
}

class ResourcesHeader
{
public:
    ResourcesSection resource;
    ulong physicalAddr;
    ResourceInfo[] resourceInfos;

    this(ResourcesSection resource, ulong physicalAddr, ResourceInfo[] resourceInfos)
    {
        this.resource = resource;
        this.physicalAddr = physicalAddr;
        this.resourceInfos = resourceInfos;
    }

    alias resource this;
}

public struct ResourcesSection
{
public:
    char[4] signature;
    uint readerCount;
    uint readerTypeLength;
    char[] readerType;
    uint resversion;
    uint resourceCount;
    uint resourceTypeCount;
    char[][] resourceTypes;
    uint[] resourceNameOffsets;
    uint dataSectionOffset;
}

public struct ResourceInfo
{
public:
    char[] name;
    uint offset;
}

public struct Resource
{
public:
    char[] name;
    char[] value;
}+/