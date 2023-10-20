module vm.typectxt;

import vm.typehandle;

public struct SigTypeContext
{
    // Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation classInst;
    Instantiation methodInst;
}