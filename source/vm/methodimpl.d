module godwit.methodimpl;

import godwit.method;
import godwit.state;

// Used in cases like virtual methods, where a method can be implemented, derived, and or overriden
public struct MethodImpl
{
public:
    uint* m_slots;
    // The MethodDesc that this MethodImpl implements
    MethodDesc* m_implement;

    mixin accessors;
}
