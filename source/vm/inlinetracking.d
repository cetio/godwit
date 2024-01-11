module godwit.inlinetracking;

import godwit.ceeload;
import godwit.llv.traits;

public struct PersistentInlineTrackingMapR2R
{
public:
    Module* m_ceemodule;
    ZapInlineeRecord* m_inlineeIndex;
    uint m_inlineeIndexSize;
    ubyte* m_inlinersBuffer;
    uint m_inlinersBufferSize;

    mixin accessors;
}

public struct ZapInlineeRecord
{
public:
    uint m_key;
    uint m_offset;

    mixin accessors;
}