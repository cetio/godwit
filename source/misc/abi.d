module godwit.abi;

import std.conv;
import std.traits;
import std.meta;

version (Windows)
{
    const uint a0    = rcx - 30;
    const uint a1    = rdx - 30;
    const uint a2    = r8 - 30;
    const uint a3    = r9 - 30;
    const uint a4    = 4;
    const uint a5    = 5;
}
else
{
    const uint a0    = rdi - 30;
    const uint a1    = rsi - 30;
    const uint a2    = rdx - 30;
    const uint a3    = rcx - 30;
    const uint a4    = r8 - 30;
    const uint a5    = r9 - 30;
}
const uint a6    = 6;
const uint a7    = 7;
const uint a8    = 8;
const uint a9    = 9;
const uint a10   = 10;
const uint a11   = 11;
const uint a12   = 12;
const uint a13   = 13;
const uint a14   = 14;
const uint a15   = 15;
const uint a16   = 16;
const uint a17   = 17;
const uint a18   = 18;
const uint a19   = 19;

const uint eax   = 52;
const uint ebx   = 53;
const uint ecx   = 54;
const uint edx   = 55;
const uint esi   = 56;
const uint edi   = 57;
const uint ebp   = 58;
const uint esp   = 59;

const uint rax   = 66;
const uint rbx   = 67;
const uint rcx   = 68;
const uint rdx   = 69;
const uint rsi   = 70;
const uint rdi   = 71;
const uint r8    = 72;
const uint r9    = 73;
const uint r10   = 74;
const uint r11   = 75;
const uint r12   = 76;
const uint r13   = 77;
const uint r14   = 78;
const uint r15   = 79;

const uint xmm0  = 86;
const uint xmm1  = 87;
const uint xmm2  = 88;
const uint xmm3  = 89;
const uint xmm4  = 90;
const uint xmm5  = 91;
const uint xmm6  = 92;
const uint xmm7  = 93;
const uint xmm8  = 94;
const uint xmm9  = 95;
const uint xmm10 = 96;
const uint xmm11 = 97;
const uint xmm12 = 98;
const uint xmm13 = 99;
const uint xmm14 = 101;
const uint xmm15 = 103;

const string[uint] register;
const string[][uint] pair;

static this()
{
    register = [ 
        eax: "EAX",
        ebx: "EBX",
        ecx: "ECX",
        edx: "EDX",
        esi: "ESI",
        edi: "EDI",
        ebp: "EBP",
        esp: "ESP",
        rax: "RAX",
        rbx: "RBX",
        rcx: "RCX",
        rdx: "RDX",
        rsi: "RSI",
        rdi: "RDI",
        r8: "R8",
        r9: "R9",
        r10: "R10",
        r11: "R11",
        r12: "R12",
        r13: "R13",
        r14: "R14",
        r15: "R15",
        xmm0: "XMM0",
        xmm1: "XMM1",
        xmm2: "XMM2",
        xmm3: "XMM3",
        xmm4: "XMM4",
        xmm5: "XMM5",
        xmm6: "XMM6",
        xmm7: "XMM7",
        xmm8: "XMM8",
        xmm9: "XMM9",
        xmm10: "XMM10",
        xmm11: "XMM11",
        xmm12: "XMM12",
        xmm13: "XMM13",
        xmm14: "XMM14",
        xmm15: "XMM15",
    ];
    pair = [
        eax: ["EAX", "EBX"],
        ecx: ["ECX", "EDX"],
        esi: ["ESI", "EDI"],
        ebp: ["EBP", "ESP"],
        rax: ["RAX", "RBX"],
        rcx: ["RCX", "RDX"], 
        rsi: ["RSI", "RDI"],
        r8: ["R8", "R9"],
        r10: ["R10", "R11"], 
        r12: ["R12", "R13"],
        r14: ["R14", "R15"],
    ];
}
/*const string[][uint] arrayPair = [
rcx: ["RCX", "RDX"], 
rdx: ["RDX", "R8"], 
r8: ["R8", "R9"],
];*/

// MSABI
version (Windows)
{
    alias isFloat(T) = Alias!(__traits(isFloating, T));
    alias isNative(T) = Alias!(__traits(isScalar, T) || ((is(T == struct) || is(T == union) || is(T == enum)) && (T.sizeof == 1 || T.sizeof == 2 || T.sizeof == 4 || T.sizeof == 8)));
    alias isPair(T) = Alias!false;
    alias isOverflow(T) = Alias!false;
    alias isSplit(T) = Alias!(isFloat!T && T.sizeof > 8);
}
// SystemV
else
{
    alias isFloat(T) = Alias!(__traits(isFloating, T) || is(T == string) || is(T == char[]));
    alias isNative(T) = Alias!(__traits(isScalar, T) || ((is(T == struct) || is(T == union) || is(T == enum)) && (T.sizeof <= 8)));
    alias isPair(T) = Alias!(!isFloat!T && is(T == struct) && T.sizeof > 8 && T.sizeof <= 32);
    alias isOverflow(T) = Alias!(!isFloat!T && T.sizeof > 16 && T.sizeof <= 32);
    alias isSplit(T) = Alias!(isFloat!T && T.sizeof > 8);
}

alias FLOAT = float;
alias NATIVE = ptrdiff_t;
alias ARRAY = int[];
public struct REFERENCE { ubyte[33] bytes; }

static void prep(uint COUNT)()
{
    static if (COUNT > 4)
        mixin("asm { add RSP, "~((COUNT - 4) * 16 + 40).to!string~"; }");
}

static shared ubyte[8] movBuff;
/// All chained uses of mov must be enclosed in a scope using `{..}`
/// Failure to do this will result in registers being overwritten by other movs, as this template uses `scope (exit)` for inline asm!
public template mov(uint ID, alias VAR, AS = void, bool REUSE = false)
{
    static if (is(AS == void))
        alias T = typeof(VAR);
    else
        alias T = AS;

    static if (ID >= eax)
        const string mov()
        {
            static if (isFloat!T)
            {
                static if (ID > xmm0 || ID < xmm15)
                    pragma(msg, "Floats can only be stored in XMM registers, not "~register[ID]~", UB may occur!");

                static if (isSplit!T)
                    return (!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"])[0];
                        "~(!REUSE ? "ulong " : "" )~"low"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[8.."~(T.sizeof >= 16 ? 16 : T.sizeof).to!string~"])[0];
                            mixin(\"asm { pinsrq "~register[ID]~", high"~__traits(identifier, VAR)~", 0; }\");
                                mixin(\"asm { pinsrq "~register[ID]~", low"~__traits(identifier, VAR)~", 1; }\");";

                return (!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"])[0];
                    scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high"~__traits(identifier, VAR)~"; }\");";
            }
            else static if (isPair!T)
            {
                pragma(msg, fullyQualifiedName!T~" is being put into register "~register[ID]~" but is being paired with register "~pair[ID][1]~", this behavior may be unintentional!");

                //static if (isOverflow!T)
                return (!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"])[0];
                    "~(!REUSE ? "ulong " : "" )~"low"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[8.."~(T.sizeof >= 16 ? 16 : T.sizeof).to!string~"])[0];
                        scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][0]~", high"~__traits(identifier, VAR)~"; }\");
                            scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][1]~", low"~__traits(identifier, VAR)~"; }\");";
            }   
            else static if (isNative!T)
            {
                return (!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"])[0];
                    scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high"~__traits(identifier, VAR)~"; }\");";
            }
            else static if (isNative!T)
            {
                return (!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = *cast(ulong*)&((movBuff = new ubyte[8])[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"] = (cast(ubyte*)&"~__traits(identifier, VAR)~")[0.."~(T.sizeof >= 8 ? 8 : T.sizeof).to!string~"])[0];
                    scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high"~__traits(identifier, VAR)~"; }\");";
            }
            else
            {
                // Wrong?
                // MSABI: Array e0 ptr -> array length (sequential)
                // SYSV: Array e0 ptr (no len)
                return fullyQualifiedName!T~" "~__traits(identifier, VAR)~"MOV2 = "~__traits(identifier, VAR)~".dup;
                    "~(!REUSE ? "ulong " : "" )~"high"~__traits(identifier, VAR)~" = cast(ulong)&"~__traits(identifier, VAR)~"MOV2;
                        scope (exit) mixin(\"asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high"~__traits(identifier, VAR)~"; }\");";
            }
        }
}
/*static void move(uint ID, T)(T val)
{
ulong high = (cast(ulong*)&val)[0];
ulong low = (cast(ulong*)&val)[1];
ptrdiff_t pT = cast(ptrdiff_t)&val;

alias isNative = conventions!(T.sizeof).isNative!(conventions!(T.sizeof).getAttr!T);
alias isPair = conventions!(T.sizeof).isPair!(conventions!(T.sizeof).getAttr!T);
alias isSplit = conventions!(T.sizeof).isSplit!(conventions!(T.sizeof).getAttr!T);
alias isOverflow = conventions!(T.sizeof).isOverflow;

static if (ID >= eax)
{
static if (!((conventions!(T.sizeof).getAttr!T & COM.Float) != 0) && !((conventions!(T.sizeof).getAttr!T & COM.Reference) != 0))
{
static if (!isNative)
throw new Exception("Strongbox with size of "~(T.sizeof).to!string~" cannot fit in register "~register[ID]~"!\n"~(isPair ? "DID you mean to make the Strongbox COM.Pairable?" : ""));

static if (((conventions!(T.sizeof).getAttr!T & COM.Pairable) != 0))
{
static if (ID % 2 == 0)
{
static if (isOverflow)
{
ulong ovhigh = (cast(ulong*)&this)[2];
ulong ovlow = (cast(ulong*)&this)[3];
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][0]~", ovhigh; }");
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][1]~", ovlow; }");
mixin("asm { push, "~pair[ID][1]~"; }");
mixin("asm { push, "~pair[ID][0]~"; }");
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][0]~", bytes[0..8]; }");
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][1]~", low; }");
}
else
{
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][0]~", high; }");
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~pair[ID][1]~", low; }");
}
}
else
{
throw new Exception("Strongbox with size of "~SIZE.to!string~" can be paired, but not using "~register[ID]~", as it has no possible pair!");
}
}
else
{
pragma(msg, "asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high; }");
mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", high; }");
}
}
else static if (((conventions!(T.sizeof).getAttr!T & COM.Float) != 0) && ID >= xmm0)
{
static if (isSplit)
{
mixin("asm { movq "~register[ID]~", high; }");
mixin("asm { movq "~register[ID]~"[8], low; }");
}
else
{
mixin("asm { movq "~register[ID]~", high; }");
}
}
else static if (((conventions!(T.sizeof).getAttr!T & COM.Reference) != 0))
{
static if (ptrdiff_t.sizeof == int.sizeof && ID >= rax && ID <= r15)
mixin("asm { movsx "~register[ID]~", pT; }");

mixin("asm { mov"~(ID >= xmm0 ? "q " : " ")~register[ID]~", pT; }");
}
}
else
{
static if (ID > 30)
{
val.move!(((conventions!(T.sizeof).getAttr!T & COM.Float) != 0) ? ID + 50 : ID + 30);
}
else
{
static if (!((conventions!(T.sizeof).getAttr!T & COM.Float) != 0))
{
val.move!r10;
static if (!((conventions!(T.sizeof).getAttr!T & COM.Reference) != 0) && isNative && isPair)
{
// Does not work
mixin("asm { mov [RSP + "~((ID - 4) * 8).to!string~"], R10; }");
mixin("asm { mov [RSP + "~((ID - 4) * 8).to!string~"], R11; }");
}
else
{
pragma(msg, "asm { mov [RSP + "~((ID - 4) * 8 + 32).to!string~"], R10; }");
mixin("asm { mov [RSP + "~((ID - 4) * 8 + 32).to!string~"], R10; }");
}
}
else
{
val.move!xmm8;
static if (isSplit)
{
// Does not work
mixin("asm { movq [RSP + "~((ID - 4) * 8).to!string~"], XMM8; }");
mixin("asm { movq [RSP + "~((ID - 4) * 8).to!string~"], XMM8[8]; }");
}
else
{
mixin("asm { movq [RSP + "~((ID - 4) * 8).to!string~"], XMM8; }");
}
}
}
}
}*/