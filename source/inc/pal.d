module godwit.pal;

import godwit.llv.traits;

public struct ExceptionRecord
{
public:
final:
    uint m_exceptionCode;
    uint m_exceptionFlags;
    ExceptionRecord* m_exceptionRecord;
    void* m_exceptionAddress;
    uint m_numParams;
    uint*[15] m_exceptionInfo;

    mixin accessors;
}

public struct ExceptionPointers
{
public:
final:
    ExceptionRecord* m_exceptionRecord;
    Context* m_context;

    mixin accessors;
}

public struct FloatingSaveArea
{
public:
final:
    uint m_control;
    uint m_status;
    uint m_tag;
    uint m_errorOffset;
    uint m_errorSelector;
    uint m_dataOffset;
    uint m_dataSelector;
    ubyte[80] m_registerArea;
    uint m_cr0NPXState;

    mixin accessors;
}

public struct Context
{
public:
final:
    uint m_contextFlags;
    uint m_dr0PAL;
    uint m_dr1PAL;
    uint m_dr2PAL;
    uint m_dr3PAL;
    uint m_dr4PAL;
    uint m_dr5PAL;
    uint m_dr6PAL;
    uint m_dr7PAL;
    FloatingSaveArea m_floatSave;
    uint m_segGsPAL;
    uint m_segFsPAL;
    uint m_segEsPAL;
    uint m_segDsPAL;
    uint m_edi;
    uint m_esi;
    uint m_ebx;
    uint m_edx;
    uint m_ecx;
    uint m_eax;
    uint m_ebp;
    uint m_eip;
    uint m_segCs;
    uint m_eflags;
    uint m_esp;
    uint m_segSs;
    ubyte[512] m_extendedRegisters;

    mixin accessors;
}