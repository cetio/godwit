module godwit.core.type;

import godwit.backend.vm.methodtable;
import godwit.core.method;
import godwit.core.field;
import godwit.backend.metadata;
import godwit.backend.vm.eeclass;

public struct Type
{
package:
final:
    MethodTable* methodTable;

public:
    string name()
    {
        throw new Exception("Unimplemented");
    }

    uint sizeOf()
    {
        return methodTable.baseSize - cast(uint)(2 * size_t.sizeof);
    }
    
    Method[] methods()
    {
        if (methodTable.eeClass.chunks == null)
            return null;

        Method[] ret;
        foreach (method; methodTable.eeClass.chunks.methods)
            ret ~= cast(Method)method;
        return ret;
    }

    Field[] fields()
    {
        Field[] ret;
        foreach (field; methodTable.eeClass.fields)
            ret ~= cast(Field)field;
        return ret;
    }

    TypeDef token()
    {
        return methodTable.token;
    }
}