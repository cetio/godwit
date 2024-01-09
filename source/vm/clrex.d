module godwit.clrex;

import godwit.method;
import godwit.ex;
import godwit.objects;
import godwit.mem.state;

public struct StackTraceInfo
{
public:
    // for building stack trace info
    // pointer to stack trace storage
    StackTraceElement*  m_pStackTrace;
    // size of stack trace storage
    uint m_stackTrace;     
    // current frame in stack trace
    uint m_frameCount;      
    // number of items in the Dynamic Method array
    uint m_dynamicMethodItems; 
    // index of the next location where the resolver object will be stored
    uint m_currentDynamicIndex; 

    mixin accessors;
}

public struct StackTraceElement
{
public:
    @flags enum StackTraceElementFlags : int
    {
        // Set if this element represents the last frame of the foreign exception stack trace
        LastFrameFromForeign = 0x0001,
        // Set if the "ip" field has already been adjusted (decremented)
        IpAdjusted = 0x0002,
    }

    uint* m_ip;
    uint* m_sp;
    MethodDesc* m_fn;
    StackTraceElementFlags m_flags;    

    mixin accessors;
}

public struct CLRException
{
    EXException exception;
    alias exception this;

public:
    ObjectHandle m_throwableHandle;

    mixin accessors;
}

public struct EEException
{
    CLRException clrException;
    alias clrException this;

public:
    const(uint) m_kind;

    mixin accessors;
}