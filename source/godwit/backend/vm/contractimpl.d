module godwit.backend.vm.contractimpl;

import godwit.backend.vm.hash;
import godwit.backend.vm.crst;
import caiman.traits;
import godwit.impl;

public struct TypeIDMap
{
public:
final:
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
final:
    uint m_nextID;
    static if (FAT_DISPATCH_TOKENS)
    {
        uint m_nextFatID;
    }

    mixin accessors;
}

public struct DispatchTokenFat
{
public:
final:
    uint m_typeId;
    uint m_slotNum;
}