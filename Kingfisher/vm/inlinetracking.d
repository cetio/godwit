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
}

public struct ZapInlineeRecord
{
public:
    uint key;
    uint offset;
}