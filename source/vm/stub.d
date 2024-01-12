module godwit.stub;

import godwit.method;
import godwit.ceeload;
import godwit.siginfo;
import godwit.llv.traits;

public struct UMThunkMarshInfo
{
public:
final:
    ubyte* m_ilStub;
    MethodDesc* m_methodDesc;
    Module* m_ceemodule;
    Signature m_sig;

    mixin accessors;

    /*bool isCompletelyInited()
    {
        return ilStub != cast(ubyte*)1;
    }*/
}

public struct Stub
{
public:
final:
    @flags enum CodeFlags : uint
    {
        // is a MulticastDelegate
        MulticastDelegate = 0x80000000,
        // points to an external function entrypoint
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
    ushort m_patchOffset;
    MethodDesc* m_instantiatedMethod;

    mixin accessors;
}