module godwit.backend.typectxt;

import godwit.backend.typehandle;
import caiman.traits;

public struct SigTypeContext
{
public:
final:
    /// Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation m_classInst;
    Instantiation m_methodInst;

    mixin accessors;
}