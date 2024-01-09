module godwit.typectxt;

import godwit.typehandle;
import godwit.collections.state;

public struct SigTypeContext
{
public:
    // Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation m_classInst;
    Instantiation m_methodInst;

    mixin accessors;
}