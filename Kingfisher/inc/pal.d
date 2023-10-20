module inc.pal;

public struct ExceptionRecord
{
public:
    uint exceptionCode;
    uint exceptionFlags;
    ExceptionRecord* exceptionRecord;
    void* exceptionAddress;
    uint numParams;
    uint*[15] exceptionInfo;
}

public struct ExceptionPointers
{
public:
    ExceptionRecord* exceptionRecord;
    Context* context;
}

public struct FloatingSaveArea
{
public:
    uint control;
    uint status;
    uint tag;
    uint errorOffset;
    uint errorSelector;
    uint dataOffset;
    uint dataSelector;
    ubyte[80] registerArea;
    uint cr0NPXState;
}

public struct Context
{
public:
    uint contextFlags;
    uint dr0PAL;
    uint dr1PAL;
    uint dr2PAL;
    uint dr3PAL;
    uint dr4PAL;
    uint dr5PAL;
    uint dr6PAL;
    uint dr7PAL;
    FloatingSaveArea floatSave;
    uint segGsPAL;
    uint segFsPAL;
    uint segEsPAL;
    uint segDsPAL;
    uint edi;
    uint esi;
    uint ebx;
    uint edx;
    uint ecx;
    uint eax;
    uint ebp;
    uint eip;
    uint segCs;
    uint eflags;
    uint esp;
    uint segSs;
    ubyte[512] extendedRegisters;
}