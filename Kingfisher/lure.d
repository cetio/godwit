module lure;

import std.stdio : writef, write, writeln;
import std.range : repeat;
import std.conv : to;

void PrintTable(string[][] data) 
{
    size_t totalWidth = 2;
    size_t[] colWidths;

    foreach (row; data)
    {
        foreach (i, cell; row)
        {
            if (i >= colWidths.length)
                colWidths.length = i + 1;

            if (cell.length > colWidths[i])
                colWidths[i] = cell.length;
        }
    }

    foreach (width; colWidths)
        totalWidth += width + 3;

    writeln("+", '-'.repeat(totalWidth - 3), "+");

    foreach (row; data)
    {
        write("|");
        foreach (i, cell; row)
            writef(" %- *s |", colWidths[i], cell);
        writeln();
    }

    writeln("+", '-'.repeat(totalWidth - 3), "+");
}

string ToBinary(ulong value) {
    string binaryString;
    for (int i = 63; i >= 0; i--) 
        binaryString ~= ((value >> i) & 1).to!string;

    return binaryString;
}

extern (C) export void DumpRegisters()
{
    ulong rax, rbx, rcx, rdx, rsi, rdi, r8, r9, r10, r11, r12, r13, r14, r15;
    ulong rsp, rbp, rflags;

    asm 
    {
        mov rax, RAX;
        mov rbx, RBX;
        mov rcx, RCX;
        mov rdx, RDX;
        mov rsi, RSI;
        mov rdi, RDI;
        mov r8, R8;
        mov r9, R9;
        mov r10, R10;
        mov r11, R11;
        mov r12, R12;
        mov r13, R13;
        mov r14, R14;
        mov r15, R15;
        mov rsp, RSP;
        mov rbp, RBP;
        pushf;
        pop rflags;
    }

    string[][] registerData = [
        ["Register", "Value"],
        ["RAX", rax.to!string],
        ["RBX", rbx.to!string],
        ["RCX", rcx.to!string],
        ["RDX", rdx.to!string],
        ["RSI", rsi.to!string],
        ["RDI", rdi.to!string],
        ["R8", r8.to!string],
        ["R9", r9.to!string],
        ["R10", r10.to!string],
        ["R11", r11.to!string],
        ["R12", r12.to!string],
        ["R13", r13.to!string],
        ["R14", r14.to!string],
        ["R15", r15.to!string],
        ["RSP", rsp.to!string],
        ["RBP", rbp.to!string],
        ["RFLAGS", ToBinary(rflags)]
    ];

    PrintTable(registerData);
}

extern (C) export void DumpStack()
{
    ulong rsp, rbp;

    asm 
    {
        mov rsp, RSP;
        mov rbp, RBP;
    }

    string[][] stackData = [
        ["Offset", "Value"]
    ];

    ulong offset = 0;
    for (ulong* stackPtr = cast(ulong*)rbp; stackPtr >= cast(ulong*)rsp; 
         stackPtr--, offset += 8)
        stackData ~= [offset.to!string, (*stackPtr).to!string];

    PrintTable(stackData);
}