module main;

//import core.sys.windows.windows;
//import core.sys.windows.dll;
import vm.appdomain;
import vm.ceeload;
import vm.methodtable;
import vm.assembly;
import vm.loaderallocator;
import std.stdio;
import vm.eeclass;

//mixin SimpleDllMain;

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

int main()
{
    Initialize();
    readln();
    return 1;
}

extern (C) export void Initialize()
{
    import readers.stream;
    ubyte[8] bytes;
    string filePath = r"C:\Users\cet\source\repos\Kingfisher\Tests\bin\Debug\net7.0\Tests.dll";
    writeln(filePath);
    if (!exists(filePath)) {
        writeln("File not found!");
        return;
    }

    ByteStream stream = new ByteStream(filePath);

    auto dosHeader = stream.read!IMAGE_DOS_HEADER();
    if (dosHeader.e_magic != 0x5A4D)
        writeln("Not a valid PE file!");

    stream.position = dosHeader.e_lfanew;

    if (stream.read!int() != 0x4550)
        writeln("PE signature not found!");
    auto fileHeader = stream.read!IMAGE_FILE_HEADER();

    writeln("Machine = ", fileHeader.Machine.to!string(16));
    writeln("Number of Sections = ", fileHeader.NumberOfSections.to!string(16));
    writeln("Time Date Stamp = ", fileHeader.TimeDateStamp.to!string(16));
    writeln("Size of Optional Header = ", fileHeader.SizeOfOptionalHeader.to!string(16));
    writeln("Characteristics = ", fileHeader.Characteristics.to!string(16));

    writeln("DOS Header:");
    writeln("e_magic = ", dosHeader.e_magic.to!string(16));
    writeln("e_cblp = ", dosHeader.e_cblp.to!string(16));
    writeln("e_lfanew = ", dosHeader.e_lfanew.to!string(16));

}