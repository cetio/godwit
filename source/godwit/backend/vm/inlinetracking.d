module godwit.backend.vm.inlinetracking;

import godwit.backend.vm.ceeload;

public struct PersistentInlineTrackingMapR2R
{
public:
final:
    Module* ceemodule;
    ZapInlineeRecord* inlineeIndex;
    uint inlineeIndexSize;
    ubyte* inlinersBuffer;
    uint inlinersBufferSize;

}

public struct ZapInlineeRecord
{
public:
final:
    uint key;
    uint offset;

}