/**
 * Support for type lookups based on components of the type (as opposed to string).
 *        Used in:
 *        - Table of constructed types (Module::m_pAvailableParamTypes)
 *        - Types currently being loaded (ClassLoader::m_pUnresolvedClassHash)
 *
 * Type handles are in one-to-one correspondence with TypeKeys.
 * In particular, note that tokens in the key are resolved TypeDefs.
 */
module godwit.typekey;

import godwit.corhdr;
import godwit.ceeload;
import godwit.typehandle;

/**
 * Represents a TypeKey structure used for type lookups based on type components.
 */
public struct TypeKey
{
public:
    /**
     * Enumeration defining different types of elements for the TypeKey.
     * Possible values:
     *   - `ELEMENT_TYPE_CLASS` for ordinary classes and generic instantiations (including value types)
     *   - `ELEMENT_TYPE_ARRAY` and `ELEMENT_TYPE_SZARRAY` for array types
     *   - `ELEMENT_TYPE_PTR` and `ELEMENT_TYPE_BYREF` for pointer types
     *   - `ELEMENT_TYPE_FNPTR` for function pointer types
     *   - `ELEMENT_TYPE_VALUETYPE` for native value types (used in IL stubs)
     */
    CorElementType kind;
    union
    {
        /**
         * Struct for elements identified as classes (`ELEMENT_TYPE_CLASS`).
         */
        struct asClass
        {
            Module* ceemodule;
            MDToken typeDef;
            /// 0 for non-generic types
            uint numGenericArgs; 
            /// NULL for non-generic types
            TypeHandle* genericArgs;   
            // Note that for DAC builds, m_pGenericArgs is a host allocated buffer (eg. by in SigPointer::GetTypeHandleThrowing),
            // not a copy of an object marshalled by DAC.
        }
        /**
         * Struct for elements identified as parameters (`ARRAY`, `SZARRAY`, `PTR`, or `BYREF`).
         */
        struct asParam
        {
            /// Element type
            TypeHandle paramType;
            /// Non-zero for `ARRAY`, 1 for `SZARRAY`, 0 for `PTR` or `BYREF`
            uint rank;        
        }
        /**
         * Struct for elements identified as function pointers (`FNPTR`).
         */
        struct asFnPtr
        {
            /// Calling convention of the function pointer
            ubyte callConv;
            /// Number of arguments in the function
            uint numArgs;
            /// Pointer to return and argument types
            TypeHandle* retAndArgTypes;
        }
    }
}