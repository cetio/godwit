module vm.stub;

import vm.method;
import vm.ceeload;
import vm.siginfo;
import flags;

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

    bool isMulticastDelegate()
    {
        return codeFlags.hasFlag(CodeFlags.MulticastDelegate);
    }

    bool isExternalEntry()
    {
        return codeFlags.hasFlag(CodeFlags.ExternalEntry);
    }

    bool isLoaderHeap()
    {
        return codeFlags.hasFlag(CodeFlags.LoaderHeap);
    }

    bool isInstantiatingStub()
    {
        return codeFlags.hasFlag(CodeFlags.InstantiatingStub);
    }

    bool isUnwindInfo()
    {
        return codeFlags.hasFlag(CodeFlags.UnwindInfo);
    }

    bool isThunk()
    {
        return codeFlags.hasFlag(CodeFlags.Thunk);
    }

    uint getCodeBytes()
    {
        return cast(uint)codeFlags.clearMask(CodeFlags.CodeBytesMask);
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

    void setRefCount(uint newRefCount)
    {
        refCount = newRefCount;
    }

    void setCodeFlags(CodeFlags newCodeFlags)
    {
        codeFlags = newCodeFlags;
    }

    void setIsMulticastDelegate(bool state)
    {
        codeFlags.setFlag(CodeFlags.MulticastDelegate, state);
    }

    void setIsExternalEntry(bool state)
    {
        codeFlags.setFlag(CodeFlags.ExternalEntry, state);
    }

    void setIsLoaderHeap(bool state)
    {
        codeFlags.setFlag(CodeFlags.LoaderHeap, state);
    }

    void setIsInstantiatingStub(bool state)
    {
        codeFlags.setFlag(CodeFlags.InstantiatingStub, state);
    }

    void setIsUnwindInfo(bool state)
    {
        codeFlags.setFlag(CodeFlags.UnwindInfo, state);
    }

    void setIsThunk(bool state)
    {
        codeFlags.setFlag(CodeFlags.Thunk, state);
    }

    void setCodeBytes(uint newBytes)
    {
        codeFlags.setFlagMasked(CodeFlags.CodeBytesMask, newBytes);
    }

    void setNumCodeBytes(uint newNumCodeBytes)
    {
        numCodeBytes = newNumCodeBytes;
    }

    void setPatchOffset(ushort newPatchOffset)
    {
        patchOffset = newPatchOffset;
    }

    void setInstantiatedMethod(MethodDesc* newInstantiatedMethod)
    {
        instantiatedMethod = newInstantiatedMethod;
    }
}