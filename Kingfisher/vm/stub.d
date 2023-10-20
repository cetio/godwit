module vm.stub;

import vm.method;
import vm.ceeload;
import vm.siginfo;

public struct UMThunkMarshInfo
{
public:
    ubyte* ilStub;
    MethodDesc* methodDesc;
    Module* ceemodule;
    Signature sig;

    ubyte* getILStub()
    {
        return ilStub;
    }

    MethodDesc* getMethodDesc()
    {
        return methodDesc;
    }

    Module* getModule()
    {
        return ceemodule;
    }

    Signature getSig()
    {
        return sig;
    }

    bool isCompletelyInited()
    {
        return ilStub != cast(ubyte*)1;
    }
}

public struct Stub
{
public:
    enum CodeFlags : uint
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
    };

    uint refCount;
    union
    {
        CodeFlags codeFlags;
        uint numCodeBytes;
    }
    ushort patchOffset;
    MethodDesc* instantiatedMethod;

    uint getRefCount()
    {
        return refCount;
    }

    CodeFlags getCodeFlags()
    {
        return codeFlags;
    }

    uint getNumCodeBytes()
    {
        return numCodeBytes;
    }

    ushort getPatchOffset()
    {
        return patchOffset;
    }

    MethodDesc* getInstantiatedMethod()
    {
        return instantiatedMethod;
    }
}