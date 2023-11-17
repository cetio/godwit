module readers.pe.dos;

import readers.pe.coff;

public struct DOSHeader 
{
public:
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
    ubyte[e_lfanew] dosStub;

    COFFHeader* getCOFFHeader()
    {
        return cast(COFFHeader*)e_lfanew;
    }
}