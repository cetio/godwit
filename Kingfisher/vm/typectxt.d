module vm.typectxt;

import vm.typehandle;

public struct SigTypeContext
{
public:
    // Store pointers first and DWORDs second to ensure good packing on 64-bit
    Instantiation classInst;
    Instantiation methodInst;

    Instantiation getClassInst()
    {
        return classInst;
    }

    Instantiation getMethodInst()
    {
        return methodInst;
    }

    void setClassInst(Instantiation newClassInst)
    {
        classInst = newClassInst;
    }

    void setMethodInst(Instantiation newMethodInst)
    {
        methodInst = newMethodInst;
    }

}