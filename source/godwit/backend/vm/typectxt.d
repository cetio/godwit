module godwit.backend.vm.typectxt;

import godwit.backend.vm.typehandle;

public struct SigTypeContext
{
public:
final:
    /// Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation classInst;
    Instantiation methodInst;

}