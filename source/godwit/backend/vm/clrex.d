module godwit.backend.vm.clrex;

import godwit.backend.vm.method;
import godwit.backend.inc.ex;
import godwit.backend.vm.object;

public struct StackTraceInfo
{
public:
final:
    // for building stack trace info
    // pointer to stack trace storage
    StackTraceElement*  stackTrace;
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
final:
    enum StackTraceElementFlags : int
    {
        // Set if this element represents the last frame of the foreign exception stack trace
        LastFrameFromForeign = 0x0001,
        // Set if the "ip" field has already been adjusted (decremented)
        IpAdjusted = 0x0002,
    }

    uint* ip;
    uint* sp;
    MethodDesc* fn;
    StackTraceElementFlags flags;

}

public struct CLRException
{
    EXException exception;
    alias exception this;

public:
final:
    ObjectHandle throwableHandle;

}

public struct EEException
{
    CLRException clrException;
    alias clrException this;

public:
final:
    const(uint) kind;

}