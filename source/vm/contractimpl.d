module godwit.contractimpl;

import godwit.hash;
import godwit.crst;
import godwit.mem.state;

public struct TypeIDMap
{
public:
    HashMap m_idMap;
    HashMap m_mtMap;
    Crst m_lock;
    TypeIDProvider m_idProvider;
    uint m_entryCount;

    mixin accessors;
}

public struct TypeIDProvider
{
public:
    uint nextID;
    // #ifdef FAT_DISPATCH_TOKENS
    uint nextFatID;

    mixin accessors;
}