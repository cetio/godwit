module godwit.cilk;

import std.stdio;
import std.algorithm;
import std.conv;
import std.string;
import std.format;
import godwit.stream;

int main()
{
    string il = "
    ldarg.0
    ldc.i4 5
    add
    stloc.0
    ldc.i4 7
    mul
    ldloc.0
    sub
    ldc.i4 2
    div
    pop
    switch 2 2, 4
    ret";

    writeln("[cilk-asm]");
    writeln(assemble(il));

    writeln("[cilk-disasm]");
    writeln(disassemble(assemble(il)));
    readln();
    return 0;
}

ubyte[] assemble(string str)
{
    ubyte[] assembly;
    const string[string] prefixes = [
        "no": "no.",
        "tail": "tail.",
        "volatile": "volatile.",
        "constrained": "constrained.",
        "readonly": "readonly."
    ];

    foreach (line; str.strip.splitLines)
    {
        auto parts = line.strip.splitter(" ");

        string mnemonic = parts.front;
        parts.popFront();
        string operand = parts.empty ? "" : parts.join(" ");

        foreach (key, val; prefixes)
        {
            if (mnemonic.startsWith(val))
            {
                assembly ~= assemble(key);
                mnemonic = mnemonic[val.length..$];
            }
        }

        switch (mnemonic)
        {
            case "beq":
            case "bge":
            case "bge.un":
            case "bgt":
            case "bgt.un":
            case "ble":
            case "ble.un":
            case "bne.un":
            case "br":
            case "brfalse":
            case "brinst":
            case "brnull":
            case "brtrue":
            case "brzero":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!int;
                assembly ~= (cast(ubyte*)&op)[0..int.sizeof];
                break;
            case "beq.s":
            case "bge.s":
            case "bge.un.s":
            case "bgt.s":
            case "bgt.un.s":
            case "ble.s":
            case "ble.un.s":
            case "bne.un.s":
            case "br.s":
            case "brfalse.s":
            case "brinst.s":
            case "brnull.s":
            case "brtrue.s":
            case "brzero.s":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!byte;
                assembly ~= (cast(ubyte*)&op)[0..byte.sizeof];
                break;
            case "calli":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!ptrdiff_t;
                assembly ~= (cast(ubyte*)&op)[0..ptrdiff_t.sizeof];
                break;
            case "box":
            case "call":
            case "callvirt":
            case "castclass":
            case "cpobj":
            case "isinst":
            case "jmp":
            case "ldelem":
            case "ldelema":
            case "ldfld":
            case "ldflda":
            case "ldobj":
            case "ldsfld":
            case "ldsflda":
            case "ldstr":
            case "ldtoken":
            case "mkrefany":
            case "newarr":
            case "newobj":
            case "refanyval":
            case "stelem":
            case "stfld":
            case "stobj":
            case "stsfld":
            case "unbox":
            case "unbox.any":
            case "initobj":
            case "ldftn":
            case "sizeof":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!uint;
                assembly ~= (cast(ubyte*)&op)[0..uint.sizeof];
                break;
            case "ldarg.s":
            case "ldarga.s":
            case "ldloc.s":
            case "ldloca.s":
            case "starg.s":
            case "stloc.s":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!ubyte;
                assembly ~= (cast(ubyte*)&op)[0..ubyte.sizeof];
                break;
            case "ldarg":
            case "ldarga":
            case "ldloc":
            case "ldloca":
            case "starg":
            case "stloc":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!ushort;
                assembly ~= (cast(ubyte*)&op)[0..ushort.sizeof];
                break;
            case "ldc.i4.s":
            case "leave.s":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!byte;
                assembly ~= (cast(ubyte*)&op)[0..byte.sizeof];
                break;
            case "ldc.i4":
            case "leave":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!int;
                assembly ~= (cast(ubyte*)&op)[0..int.sizeof];
                break;
            case "ldc.i8":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!long;
                assembly ~= (cast(ubyte*)&op)[0..long.sizeof];
                break;
            case "ldc.r4":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!float;
                assembly ~= (cast(ubyte*)&op)[0..float.sizeof];
                break;
            case "ldc.r8":
                assembly ~= instructions[mnemonic];
                auto op = operand.to!double;
                assembly ~= (cast(ubyte*)&op)[0..double.sizeof];
                break;
            case "switch":
                import std.array;
                assembly ~= instructions[mnemonic];
                string[] array = operand.replace(",", "").split(" ");
                auto op = array[0].to!uint;
                uint index = 1;
                assembly ~= (cast(ubyte*)&op)[0..uint.sizeof];
                while (index < op + 1)
                {
                    int item =  array[index++].to!int;
                    assembly ~= (cast(ubyte*)&item)[0..int.sizeof];
                }
                break;
            default:
                if (mnemonic !in instructions || operand != null)
                    throw new Exception("Invalid mnemonic or operand: "~line);
                assembly ~= instructions[mnemonic];
                break;
        }
    }

    return assembly;
}

string disassemble(ubyte[] bytes)
{
    string disassembly;
    string prefix;
    bool keepPrefix;
    Stream stream = new Stream(bytes);

    while (stream.mayRead)
    {
        if (!instructions.keys.filter!(key => instructions[key] == stream.peek!ubyte(1)).empty)
        {
            string mnemonic = instructions.keys.filter!(key => instructions[key] == stream.peek!ubyte(1)).front;
            stream.step!ubyte(1);
            
            if (mnemonic.startsWith("ld") || mnemonic.startsWith("new") || mnemonic == "mkrefany" || mnemonic == "dup" || mnemonic == "push")
                prefix = '+'~prefix;
            else if (mnemonic.startsWith("st") || mnemonic.startsWith("loc") || mnemonic.startsWith("init") || mnemonic.startsWith("call") || 
                     mnemonic.startsWith("add") || mnemonic.startsWith("sub") || mnemonic.startsWith("mul") || mnemonic.startsWith("div") 
                     || mnemonic.startsWith("rem") || mnemonic == "pop" || mnemonic == "and" || mnemonic == "xor" || mnemonic == "or" || 
                     mnemonic == "shl" || mnemonic == "shr" || mnemonic == "rethrow" || mnemonic.startsWith("cp") || mnemonic == "ret")
                prefix = '-'~prefix;
            else
                prefix = '~'~prefix;

            // owo icky!
            switch (mnemonic)
            {
                case "beq":
                case "bge":
                case "bge.un":
                case "bgt":
                case "bgt.un":
                case "ble":
                case "ble.un":
                case "bne.un":
                case "br":
                case "brfalse":
                case "brinst":
                case "brnull":
                case "brtrue":
                case "brzero":
                    disassembly ~= format("%08d: %s%s $loc_%X\n", stream.position - 1, prefix, mnemonic, stream.read!int);
                    break;
                case "beq.s":
                case "bge.s":
                case "bge.un.s":
                case "bgt.s":
                case "bgt.un.s":
                case "ble.s":
                case "ble.un.s":
                case "bne.un.s":
                case "br.s":
                case "brfalse.s":
                case "brinst.s":
                case "brnull.s":
                case "brtrue.s":
                case "brzero.s":
                    disassembly ~= format("%08d: %s%s $loc_%X\n", stream.position - 1, prefix, mnemonic, stream.read!byte);
                    break;
                case "calli":
                    disassembly ~= format("%08d: %s%s %08d\n", stream.position - 1, prefix, mnemonic, stream.read!ptrdiff_t);
                    break;
                case "box":
                case "call":
                case "callvirt":
                case "castclass":
                case "cpobj":
                case "isinst":
                case "jmp":
                case "ldelem":
                case "ldelema":
                case "ldfld":
                case "ldflda":
                case "ldobj":
                case "ldsfld":
                case "ldsflda":
                case "ldstr":
                case "ldtoken":
                case "mkrefany":
                case "newarr":
                case "newobj":
                case "refanyval":
                case "stelem":
                case "stfld":
                case "stobj":
                case "stsfld":
                case "unbox":
                case "unbox.any":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!uint);
                    break;
                case "ldarg.s":
                case "ldarga.s":
                case "ldloc.s":
                case "ldloca.s":
                case "starg.s":
                case "stloc.s":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!ubyte);
                    break;
                case "ldc.i4.s":
                case "leave.s":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!byte);
                    break;
                case "ldc.i4":
                case "leave":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!int);
                    break;
                case "ldc.i8":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, mnemonic, stream.read!long);
                    break;
                case "ldc.r4":
                    disassembly ~= format("%08d: %s%s %f\n", stream.position - 1, prefix, mnemonic, stream.read!float);
                    break;
                case "ldc.r8":
                    disassembly ~= format("%08d: %s%s %f\n", stream.position - 1, prefix, mnemonic, stream.read!double);
                    break;
                case "switch":
                    disassembly ~= format("%08d: %s%s %s\n", stream.position - 1, prefix, mnemonic, stream.read!int(stream.read!uint).to!string);
                    break;
                default:
                    disassembly ~= format("%08d: %s%s\n", stream.position - 1, prefix, mnemonic);
                    break;
            }
        }
        else if (stream.mayRead(2) < bytes.length &&
                 !instructions.keys.filter!(key => instructions[key] == stream.peek!ubyte(2)).empty)
        {
            string mnemonic = instructions.keys.filter!(key => instructions[key] == stream.peek!ubyte(2)).front;
            stream.step!ubyte(2);

            if (mnemonic.startsWith("ld") || mnemonic.startsWith("new") || mnemonic == "mkrefany" || mnemonic == "dup" || mnemonic == "push")
                prefix = '+'~prefix;
            else if (mnemonic.startsWith("st") || mnemonic.startsWith("loc") || mnemonic.startsWith("init") || mnemonic.startsWith("call") || 
                     mnemonic.startsWith("add") || mnemonic.startsWith("sub") || mnemonic.startsWith("mul") || mnemonic.startsWith("div") 
                     || mnemonic.startsWith("rem") || mnemonic == "pop" || mnemonic == "and" || mnemonic == "xor" || mnemonic == "or" || 
                     mnemonic == "shl" || mnemonic == "shr" || mnemonic == "rethrow" || mnemonic.startsWith("cp") || mnemonic == "ret")
                prefix = '-'~prefix;
            else
                prefix = '~'~prefix;

            switch (mnemonic)
            {
                case "initobj":
                case "ldftn":
                case "sizeof":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!uint);
                    break;
                case "ldarg":
                case "ldarga":
                case "ldloc":
                case "ldloca":
                case "starg":
                case "stloc":
                    disassembly ~= format("%08d: %s%s %X\n", stream.position - 1, prefix, mnemonic, stream.read!ushort);
                    break;
                case "no":
                    prefix ~= "no.";
                    keepPrefix = true;
                    break;
                case "tail":
                    prefix ~= "tail.";
                    keepPrefix = true;
                    break;
                case "volatile":
                    prefix ~= "volatile.";
                    keepPrefix = true;
                    break;
                case "constrained":
                    prefix ~= "constrained.";
                    keepPrefix = true;
                    break;
                case "readonly":
                    prefix ~= "readonly.";
                    keepPrefix = true;
                    break;
                default:
                    disassembly ~= format("%08d: %s%s\n", stream.position - 1, prefix, mnemonic);
                    break;
            }
        }
        else
        {
            if (stream.mayRead(2))
                throw new Exception(format("Invalid bytes for an IL instruction (0..1): %X", stream.read!ubyte));

            throw new Exception(format("Invalid bytes for an IL instruction (0..2): %(%02X%)", stream.read!ubyte(2)));
        }
        
        // Gross! T.T
        if (keepPrefix)
            keepPrefix = false;
        else
            prefix = null;
    }
    return disassembly.strip;
}

ubyte[][string] instructions = [
    "add": [0x58],
    "add.ovf": [0xD6],
    "add.ovf.un": [0xD7],
    "and": [0x5F],
    "arglist": [0xFE, 0x00],
    "beq": [0x3B],
    "beq.s": [0x2E],
    "bge": [0x3C],
    "bge.s": [0x2F],
    "bge.un": [0x41],
    "bge.un.s": [0x34],
    "bgt": [0x3D],
    "bgt.s": [0x30],
    "bgt.un": [0x42],
    "bgt.un.s": [0x35],
    "ble": [0x3E],
    "ble.s": [0x31],
    "ble.un": [0x43],
    "ble.un.s": [0x36],
    "blt": [0x3F],
    "blt.s": [0x32],
    "blt.un": [0x44],
    "blt.un.s": [0x37],
    "bne.un": [0x40],
    "bne.un.s": [0x33],
    "box": [0x8C],
    "br": [0x38],
    "br.s": [0x2B],
    "break": [0x01],
    "brfalse": [0x39],
    "brfalse.s": [0x2C],
    "brinst": [0x3A],
    "brinst.s": [0x2D],
    "brnull": [0x39],
    "brnull.s": [0x2C],
    "brtrue": [0x3A],
    "brtrue.s": [0x2D],
    "brzero": [0x39],
    "brzero.s": [0x2C],
    "call": [0x28],
    "calli": [0x29],
    "callvirt": [0x6F],
    "castclass": [0x74],
    "ceq": [0xFE, 0x01],
    "cgt": [0xFE, 0x02],
    "cgt.un": [0xFE, 0x03],
    "ckfinite": [0xC3],
    "clt": [0xFE, 0x04],
    "clt.un": [0xFE, 0x05],
    "constrained": [0xFE, 0x16],
    "conv.i": [0xD3],
    "conv.i1": [0x67],
    "conv.i2": [0x68],
    "conv.i4": [0x69],
    "conv.i8": [0x6A],
    "conv.ovf.i": [0xD4],
    "conv.ovf.i.un": [0x8A],
    "conv.ovf.i1": [0xB3],
    "conv.ovf.i1.un": [0x82],
    "conv.ovf.i2": [0xB5],
    "conv.ovf.i2.un": [0x83],
    "conv.ovf.i4": [0xB7],
    "conv.ovf.i4.un": [0x84],
    "conv.ovf.i8": [0xB9],
    "conv.ovf.i8.un": [0x85],
    "conv.ovf.u": [0xD5],
    "conv.ovf.u.un": [0x8B],
    "conv.ovf.u1": [0xB4],
    "conv.ovf.u1.un": [0x86],
    "conv.ovf.u2": [0xB6],
    "conv.ovf.u2.un": [0x87],
    "conv.ovf.u4": [0xB8],
    "conv.ovf.u4.un": [0x88],
    "conv.ovf.u8": [0xBA],
    "conv.ovf.u8.un": [0x89],
    "conv.r.un": [0x76],
    "conv.r4": [0x6B],
    "conv.r8": [0x6C],
    "conv.u": [0xE0],
    "conv.u1": [0xD2],
    "conv.u2": [0xD1],
    "conv.u4": [0x6D],
    "conv.u8": [0x6E],
    "cpblk": [0xFE, 0x17],
    "cpobj": [0x70],
    "div": [0x5B],
    "div.un": [0x5C],
    "dup": [0x25],
    "endfault": [0xDC],
    "endfilter": [0xFE, 0x11],
    "endfinally": [0xDC],
    "initblk": [0xFE, 0x18],
    "initobj": [0xFE, 0x15],
    "isinst": [0x75],
    "jmp": [0x27],
    "ldarg": [0xFE, 0x09],
    "ldarg.0": [0x02],
    "ldarg.1": [0x03],
    "ldarg.2": [0x04],
    "ldarg.3": [0x05],
    "ldarg.s": [0x0E],
    "ldarga": [0xFE, 0x0A],
    "ldarga.s": [0x0F],
    "ldc.i4": [0x20],
    "ldc.i4.0": [0x16],
    "ldc.i4.1": [0x17],
    "ldc.i4.2": [0x18],
    "ldc.i4.3": [0x19],
    "ldc.i4.4": [0x1A],
    "ldc.i4.5": [0x1B],
    "ldc.i4.6": [0x1C],
    "ldc.i4.7": [0x1D],
    "ldc.i4.8": [0x1E],
    "ldc.i4.m1": [0x15],
    "ldc.i4.s": [0x1F],
    "ldc.i8": [0x21],
    "ldc.r4": [0x22],
    "ldc.r8": [0x23],
    "ldelem": [0xA3],
    "ldelem.i": [0x97],
    "ldelem.i1": [0x90],
    "ldelem.i2": [0x92],
    "ldelem.i4": [0x94],
    "ldelem.i8": [0x96],
    "ldelem.r4": [0x98],
    "ldelem.r8": [0x99],
    "ldelem.ref": [0x9A],
    "ldelem.u1": [0x91],
    "ldelem.u2": [0x93],
    "ldelem.u4": [0x95],
    "ldelema": [0x8F],
    "ldfld": [0x7B],
    "ldflda": [0x7C],
    "ldftn": [0xFE, 0x06],
    "ldind.i": [0x4D],
    "ldind.i1": [0x46],
    "ldind.i2": [0x48],
    "ldind.i4": [0x4A],
    "ldind.i8": [0x4C],
    "ldind.r4": [0x4E],
    "ldind.r8": [0x4F],
    "ldind.ref": [0x50],
    "ldind.u1": [0x47],
    "ldind.u2": [0x49],
    "ldind.u4": [0x4B],
    "ldlen": [0x8E],
    "ldloc": [0xFE, 0x0C],
    "ldloc.0": [0x06],
    "ldloc.1": [0x07],
    "ldloc.2": [0x08],
    "ldloc.3": [0x09],
    "ldloc.s": [0x11],
    "ldloca": [0xFE, 0x0D],
    "ldloca.s": [0x12],
    "ldnull": [0x14],
    "ldobj": [0x71],
    "ldsfld": [0x7E],
    "ldsflda": [0x7F],
    "ldstr": [0x72],
    "ldtoken": [0xD0],
    "ldvirtftn": [0xFE, 0x07],
    "leave": [0x2A],
    "leave.s": [0x1F],
    "localloc": [0xFE, 0x0F],
    "mkrefany": [0xC6],
    "mul": [0x5A],
    "mul.ovf": [0xD8],
    "mul.ovf.un": [0xD9],
    "neg": [0x65],
    "newarr": [0x8D],
    "newobj": [0x73],
    "no": [0xFE, 0x19],
    "nop": [0x00],
    "not": [0x66],
    "or": [0x60],
    "pop": [0x26],
    "readonly": [0xFE, 0x1E],
    "refanytype": [0xC2],
    "refanyval": [0xC7],
    "rem": [0x5D],
    "rem.un": [0x5E],
    "ret": [0x2A],
    "rethrow": [0xFE, 0x1A],
    "shl": [0x62],
    "shr": [0x63],
    "shr.un": [0x64],
    "sizeof": [0xFE, 0x1C],
    "starg": [0xFE, 0x0B],
    "starg.s": [0x10],
    "stelem": [0xA4],
    "stelem.i": [0x9F],
    "stelem.i1": [0x9C],
    "stelem.i2": [0x9D],
    "stelem.i4": [0x9E],
    "stelem.i8": [0xA0],
    "stelem.r4": [0xA1],
    "stelem.r8": [0xA2],
    "stelem.ref": [0xA3],
    "stfld": [0x7D],
    "stind.i": [0x51],
    "stind.i1": [0x52],
    "stind.i2": [0x53],
    "stind.i4": [0x54],
    "stind.i8": [0x55],
    "stind.r4": [0x56],
    "stind.r8": [0x57],
    "stind.ref": [0x58],
    "stloc": [0xFE, 0x0E],
    "stloc.0": [0x0A],
    "stloc.1": [0x0B],
    "stloc.2": [0x0C],
    "stloc.3": [0x0D],
    "stloc.s": [0x13],
    "stobj": [0x81],
    "stsfld": [0x80],
    "sub": [0x59],
    "sub.ovf": [0xDA],
    "sub.ovf.un": [0xDB],
    "switch": [0x45],
    "tail": [0xFE, 0x14],
    "throw": [0x7A],
    "unaligned": [0xFE, 0x12],
    "unbox": [0x79],
    "unbox.any": [0xA5],
    "volatile": [0xFE, 0x13],
    "xor": [0x61]
];