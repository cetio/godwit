module vm.clrex;

import vm.method;
import inc.ex;
import vm.objects;

public struct StackTraceInfo
{
public:
    // for building stack trace info
    // pointer to stack trace storage
    StackTraceElement*  m_pStackTrace;
    // size of stack trace storage
    uint stackTrace;     
    // current frame in stack trace
    uint frameCount;      
    // number of items in the Dynamic Method array
    uint dynamicMethodItems; 
    // index of the next location where the resolver object will be stored
    uint currentDynamicIndex; 
}

public struct StackTraceElement
{
public:
    enum StackTraceElementFlags : int
    {
        // Set if this element represents the last frame of the foreign exception stack trace
        STEF_LAST_FRAME_FROM_FOREIGN_STACK_TRACE = 0x0001,
        // Set if the "ip" field has already been adjusted (decremented)
        STEF_IP_ADJUSTED = 0x0002,
    };

    uint* ip;
    uint* sp;
    MethodDesc* fnptr;
    StackTraceElementFlags flags;      
}

public struct CLRException
{
<<<<<<< HEAD
    Exception exception;
=======
    EXException exception;
>>>>>>> d6d6d12 (😱😱😱)
    alias exception this;

public:
    ObjectHandle throwableHandle;
}

public struct EEException
{
    CLRException clrException;
    alias clrException this;

public:
<<<<<<< HEAD
    const RuntimeExceptionKind kind;
=======
    const uint kind;
>>>>>>> d6d6d12 (😱😱😱)
}