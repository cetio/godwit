module vm.inlinetracking;

import vm.ceeload;

public struct PersistentInlineTrackingMapR2R
{
public:
    Module* ceemodule;
    ZapInlineeRecord* inlineeIndex;
    uint inlineeIndexSize;
    ubyte* inlinersBuffer;
    uint inlinersBufferSize;

    Module* getModule()
    {
        return ceemodule;
    }

    void setModule(Module* newModule)
    {
        ceemodule = newModule;
    }

    ZapInlineeRecord* getInlineeIndex()
    {
        return inlineeIndex;
    }

    void setInlineeIndex(ZapInlineeRecord* newInlineeIndex)
    {
        inlineeIndex = newInlineeIndex;
    }

    uint getInlineeIndexSize()
    {
        return inlineeIndexSize;
    }

    void setInlineeIndexSize(uint newInlineeIndexSize)
    {
        inlineeIndexSize = newInlineeIndexSize;
    }

    ubyte* getInlinersBuffer()
    {
        return inlinersBuffer;
    }

    void setInlinersBuffer(ubyte* newInlinersBuffer)
    {
        inlinersBuffer = newInlinersBuffer;
    }

    uint getInlinersBufferSize()
    {
        return inlinersBufferSize;
    }

    void setInlinersBufferSize(uint newInlinersBufferSize)
    {
        inlinersBufferSize = newInlinersBufferSize;
    }
}

public struct ZapInlineeRecord
{
public:
    uint key;
    uint offset;

    uint getKey()
    {
        return key;
    }

    void setKey(uint newKey)
    {
        key = newKey;
    }

    uint getOffset()
    {
        return offset;
    }

    void setOffset(uint newOffset)
    {
        offset = newOffset;
    }
}