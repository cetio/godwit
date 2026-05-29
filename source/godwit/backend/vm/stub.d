module godwit.backend.vm.stub;

import godwit.backend.vm.method;
import godwit.backend.vm.ceeload;
import godwit.backend.siginfo;
import godwit.impl;
import godwit.backend.inc.shash;
import godwit.backend.vm.appdomain;
import godwit.backend.vm.crst;
import godwit.backend.vm.object;

// dllimportcallback.h

public struct UMEntryThunkCache
{
public:
final:
    SHash!(CacheElement, uint) hash;
    Crst crst;
    AppDomain* domain;

}

public struct CacheElement
{
public:
final:
    MethodDesc* methodDesc;
    UMEntryThunk* thunk;

}

public struct UMEntryThunk
{
public:
final:
    uint* managedTarget;
    MethodDesc* methodDesc;
    ObjectHandle objectHandle;
    union
    {
        UMThunkMarshInfo* umThunkMarshInfo;
        UMEntryThunk* next;
    }
    static if (DEBUG)
    {
        uint state;
    }
    // UMEntryThunkCode
    // padding                  // CC CC CC CC
    // mov r10, umEntryThunk   // 49 ba xx xx xx xx xx xx xx xx    // METHODDESC_REGISTER
    // mov rax, jmpDest        // 48 b8 xx xx xx xx xx xx xx xx    // need to ensure this imm64 is qword aligned
    // TAILJMP_RAX              // 48 FF E0
    ubyte[4] padding;
    ubyte[2] movR10;
    void* start;
    ubyte[2] movRAX;
    align(8) const ubyte* execStub;
    ubyte[3] jmpRAX;
    ubyte[5] padding2;

}

public struct UMThunkMarshInfo
{
public:
final:
    ubyte* ilStub;
    MethodDesc* methodDesc;
    Module* ceemodule;
    Signature sig;


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
    enum CodeFlags : uint
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

    uint refCount;
    union
    {
        CodeFlags codeFlags;
        uint numCodeBytes;
    }
    union
    {
        ushort patchOffset;
        MethodDesc* instantiatedMethod;
    }
    static if (DEBUG)
    {
        uint signature;
        static if (HOST_x64)
        {
            /// Ensure code after the Stub struct align to 16-bytes.
            uint padding1;
            uint padding2;
            uint padding3;
        }
    }

}