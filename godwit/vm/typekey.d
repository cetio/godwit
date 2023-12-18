module godwit.typekey;

import godwit.corhdr;
import godwit.ceeload;
import godwit.typehandle;

public struct TypeKey
{
public:
    // ELEMENT_TYPE_CLASS for ordinary classes and generic instantiations (including value types)
    // ELEMENT_TYPE_ARRAY and ELEMENT_TYPE_SZARRAY for array types
    // ELEMENT_TYPE_PTR and ELEMENT_TYPE_BYREF for pointer types
    // ELEMENT_TYPE_FNPTR for function pointer types
    // ELEMENT_TYPE_VALUETYPE for native value types (used in IL stubs)
    CorElementType kind;
    union
    {
        struct AsClass
        {
            Module* ceemodule;
            MDToken typeDef;
            // 0 for non-generic types
            uint numGenericArgs; 
            // NULL for non-generic types
            TypeHandle* genericArgs;   
            // Note that for DAC builds, m_pGenericArgs is a host allocated buffer (eg. by in SigPointer::GetTypeHandleThrowing),
            // not a copy of an object marshalled by DAC.
        }

        // m_kind = ARRAY, SZARRAY, PTR or BYREF
        struct AsParam
        {
            // Element type
            TypeHandle paramType;
            // Non-zero for ARRAY, 1 for SZARRAY, 0 for PTR or BYREF
            uint rank;        
        }

        // m_kind = FNPTR
        struct AsFnPtr
        {
            ubyte callConv;
            uint numArgs;
            TypeHandle* retAndArgTypes;
        }
    }
}