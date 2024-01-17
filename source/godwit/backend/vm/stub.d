module godwit.backend.stub;

import godwit.backend.method;
import godwit.backend.ceeload;
import godwit.backend.siginfo;
import caiman.traits;
import godwit.impl;
import godwit.backend.shash;
import godwit.backend.appdomain;
import godwit.backend.crst;
import godwit.backend.object;

// dllimportcallback.h

public struct UMEntryThunkCache
{
public:
final:
    SHash!(CacheElement, uint) m_hash;
    Crst m_crst;
    AppDomain* m_domain;
    
    mixin accessors;
}

public struct CacheElement
{
public:
final:
    MethodDesc* m_methodDesc;
    UMEntryThunk* m_thunk;

    mixin accessors;
}

public struct UMEntryThunk
{
public:
final:
    uint* m_managedTarget;
    MethodDesc* m_methodDesc;
    ObjectHandle m_objectHandle;
    union
    {
        UMThunkMarshInfo* m_umThunkMarshInfo;
        UMEntryThunk* m_next;
    }
    static if (DEBUG)
    {
        uint m_state;
    }
    // UMEntryThunkCode
    // padding                  // CC CC CC CC
    // mov r10, pUMEntryThunk   // 49 ba xx xx xx xx xx xx xx xx    // METHODDESC_REGISTER
    // mov rax, pJmpDest        // 48 b8 xx xx xx xx xx xx xx xx    // need to ensure this imm64 is qword aligned
    // TAILJMP_RAX              // 48 FF E0
    ubyte[4] m_padding;
    ubyte[2] m_movR10;
    void* m_start;
    ubyte[2] m_movRAX;
    align(8) const ubyte* m_execStub;
    ubyte[3] m_jmpRAX;
    ubyte[5] m_padding2;

    mixin accessors;
}

public struct UMThunkMarshInfo
{
public:
final:
    ubyte* m_ilStub;
    MethodDesc* m_methodDesc;
    Module* m_ceemodule;
    Signature m_sig;

    mixin accessors;

    bool isCompletelyInited()
    {
        return ilStub != cast(ubyte*)1;
    }
}

// stublink.h

public struct Stub
{
public:
final:
    @flags enum CodeFlags : uint
    {
        /// Is a MulticastDelegate?
        MulticastDelegate = 0x80000000,
        /// Points to an external function entrypoint
        ExternalEntry = 0x40000000,
        LoaderHeap = 0x20000000,
        InstantiatingStub = 0x10000000,
        UnwindInfo = 0x08000000,
        Thunk = 0x04000000,

        CodeBytesMask = Thunk - 1,
        MaxCodeBytes = CodeBytesMask + 1,
    }

    uint m_refCount;
    union
    {
        CodeFlags m_codeFlags;
        uint m_numCodeBytes;
    }
    union
    {
        ushort m_patchOffset;
        MethodDesc* m_instantiatedMethod;
    }
    static if (DEBUG)
    {
        uint m_signature;
        static if (HOST_x64)
        {
            /// Ensure code after the Stub struct align to 16-bytes.
            uint padding1;
            uint padding2;
            uint padding3;
        }
    }

    mixin accessors;
}