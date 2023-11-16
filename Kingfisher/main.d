module kingfisher;

import core.sys.windows.windows;
import core.sys.windows.dll;
import vm.appdomain;
import vm.ceeload;
import vm.methodtable;
import vm.assembly;
import vm.loaderallocator;
import std.stdio;
import vm.eeclass;

mixin SimpleDllMain;

import std.stdio;
import std.file;
import std.array;
import std.conv;

struct IMAGE_DOS_HEADER {
    ushort e_magic;
    ushort e_cblp;
    ushort e_cp;
    ushort e_crlc;
    ushort e_cparhdr;
    ushort e_minalloc;
    ushort e_maxalloc;
    ushort e_ss;
    ushort e_sp;
    ushort e_csum;
    ushort e_ip;
    ushort e_cs;
    ushort e_lfarlc;
    ushort e_ovno;
    ushort[4] e_res;
    ushort e_oemid;
    ushort e_oeminfo;
    ushort[10] e_res2;
    uint e_lfanew;
}

struct IMAGE_FILE_HEADER {
    ushort Machine;
    ushort NumberOfSections;
    uint TimeDateStamp;
    uint PointerToSymbolTable;
    uint NumberOfSymbols;
    ushort SizeOfOptionalHeader;
    ushort Characteristics;
}

extern (C) export void Initialize(Module* pmd, string filePath)
{
    filePath = r"C:\Users\cet\source\repos\Kingfisher\Tests\bin\Debug\net7.0\Tests.dll";
    writeln(filePath);
    if (!exists(filePath)) {
        writeln("File not found!");
        return;
    }

    auto fileContent = cast(ubyte[])read(filePath);
    if (fileContent.length < size_t.sizeof + size_t.sizeof) {
        writeln("Invalid file format!");
        return;
    }

    // Read DOS Header
    auto dosHeader = *cast(IMAGE_DOS_HEADER*)fileContent.ptr;

    // Check if the file is a valid PE file
    if (dosHeader.e_magic != 0x5A4D) {
        writeln("Not a valid PE file!");
        return;
    }

    // Get the offset to PE signature
    size_t peOffset = dosHeader.e_lfanew;

    // Read PE Signature (PE Header)
    auto peSignature = *cast(uint*)(fileContent.ptr + peOffset);
    if (peSignature != 0x4550) {
        writeln("PE signature not found!");
        return;
    }

    // Read IMAGE_FILE_HEADER
    auto fileHeader = *cast(IMAGE_FILE_HEADER*)(fileContent.ptr + peOffset + 4);

    writeln("Machine: ", fileHeader.Machine.to!string(16));
    writeln("Number of Sections: ", fileHeader.NumberOfSections.to!string(16));
    writeln("Time Date Stamp: ", fileHeader.TimeDateStamp.to!string(16));
    writeln("Size of Optional Header: ", fileHeader.SizeOfOptionalHeader.to!string(16));
    writeln("Characteristics: ", fileHeader.Characteristics.to!string(16));

    writeln("DOS Header:");
    writeln("e_magic: ", dosHeader.e_magic.to!string(16));
    writeln("e_cblp: ", dosHeader.e_cblp.to!string(16));
    writeln("e_lfanew: ", dosHeader.e_lfanew.to!string(16));

}