module vm.typectxt;

import vm.typehandle;
import state;

public struct SigTypeContext
{
public:
    // Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation m_classInst;
    Instantiation m_methodInst;

    mixin accessors;
}