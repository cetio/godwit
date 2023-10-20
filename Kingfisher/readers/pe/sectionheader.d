/+module readers.pe.sectionheader;

import std.stdio;
import std.conv;
import std.algorithm;
import std.ascii;
import readers.pe.utils;

// Constants for section characteristics
enum IMAGE_SCN_MEM_EXECUTE = 0x20000000;
enum IMAGE_SCN_MEM_READ = 0x40000000;
enum IMAGE_SCN_MEM_WRITE = 0x60000000;
enum IMAGE_SCN_CNT_INITIALIZED_DATA = 0x00000040;
enum IMAGE_SCN_CNT_UNINITIALIZED_DATA = 0x00000080;

/**
* Read section headers from the file.
*/
SectionHeader[] readSectionHeaders(File file, ushort numberOfSections)
{
    SectionHeader[] headers;
    headers.reserve(numberOfSections);

    foreach (i; 0..numberOfSections)
    {
        headers ~= readSectionHeader(file);
    }

    return headers;
}

/**
* Calculate the physical address from the RVA using section headers.
*/
uint physicalAddr(uint rva, SectionHeader[] sectionHeaders)
{
    uint addr;
    foreach (section; sectionHeaders)
    {
        if (section.VirtualAddress <= rva && rva < section.VirtualAddress + section.SizeOfRawData)
        {
            addr = (rva - section.VirtualAddress) + section.PointerToRawData;
            return addr;
        }
    }
    throw new Exception("Failed to Find Physical Address of RVA: " ~ rva.to!string);
}

/**
* Struct to represent a section header.
*/
public struct SectionHeader
{
public:
    char[8] name;
    union
    {
        uint physicalAddress;
        uint virtualSize;
    }
    uint virtualAddress;
    uint sizeOfRawData;
    uint pointerToRawData;
    uint pointerToRelocations;
    uint pointerToLinenumbers;
    ushort numberOfRelocations;
    ushort numberOfLinenumbers;
    uint characteristics;

    /**
    * Convert the section header to a string representation.
    */
    string toString()
    {
        return "SectionHeader<" ~ name.to!string ~ ">" ~ pointerToRawData.to!string ~ flagStrings.to!string;
    }

    /**
    * Check if the section is executable.
    */
    bool isExecutable()
    {
        return (characteristics & IMAGE_SCN_MEM_EXECUTE) != 0;
    }

    /**
    * Check if the section is readable.
    */
    bool isReadable()
    {
        return (characteristics & IMAGE_SCN_MEM_READ) != 0;
    }

    /**
    * Check if the section is writable.
    */
    bool isWritable()
    {
        return (characteristics & IMAGE_SCN_MEM_WRITE) != 0;
    }

    /**
    * Check if the section is initialized.
    */
    bool isInitialized()
    {
        return (characteristics & IMAGE_SCN_CNT_INITIALIZED_DATA) != 0;
    }

    /**
    * Check if the section is uninitialized.
    */
    bool isUninitialized()
    {
        return (characteristics & IMAGE_SCN_CNT_UNINITIALIZED_DATA) != 0;
    }

    /**
    * Get an array of flag strings.
    */
    string[] flagStrings()
    {
        string[] flags;

        if (isExecutable)
        {
            flags ~= "EXECUTE";
        }
        if (isReadable)
        {
            flags ~= "READ";
        }
        if (isWritable)
        {
            flags ~= "WRITE";
        }
        if (isInitialized)
        {
            flags ~= "Initialized";
        }
        if (isUninitialized)
        {
            flags ~= "UNinitialized";
        }

        return flags;
    }
}+/
