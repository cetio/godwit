module vm.methodimpl;

import vm.method;

// Used in cases like virtual methods, where a method can be implemented, derived, and or overriden
public struct MethodImpl
{
public:
    uint* slots;
    // The MethodDesc that this MethodImpl implements
    MethodDesc* implement;

    uint* getSlots()
    {
        return slots;
    }

    MethodDesc* getImplement()
    {
        return implement;
    }
}
