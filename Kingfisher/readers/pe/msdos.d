/+module readers.pe.msdos;

import std.stdio;
import readers.pe.utils;

public struct DOSHeader 
{
public:
    char[2] e_magic;                     // Magic number
    ushort e_cblp;                      // Bytes on last page of file
    ushort e_cp;                        // Pages in file
    ushort e_crlc;                      // Relocations
    ushort e_cparhdr;                   // Size of header in paragraphs
    ushort e_minalloc;                  // Minimum extra paragraphs needed
    ushort e_maxalloc;                  // Maximum extra paragraphs needed
    ushort e_ss;                        // Initial (relative) SS value
    ushort e_sp;                        // Initial SP value
    ushort e_csum;                      // Checksum
    ushort e_ip;                        // Initial IP value
    ushort e_cs;                        // Initial (relative) CS value
    ushort e_lfarlc;                    // File address of relocation table
    ushort e_ovno;                      // Overlay number
    ushort[4] e_res;                    // Reserved ushorts
    ushort e_oemid;                     // OEM identifier (for e_oeminfo)
    ushort e_oeminfo;                   // OEM information; e_oemid specific
    ushort[10] e_res2;                  // Reserved ushorts
    int e_lfanew;                    // File address of new exe header
}+/