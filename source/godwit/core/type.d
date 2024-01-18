module godwit.core.type;

import godwit.backend.vm.methodtable;
import godwit.core.method;
import godwit.core.field;

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
        return methodTable.eeClass.layoutInfo.managedSize;
    }
    
    extern (C) export Method[] methods()
    {
        return null;
    }

    pragma(mangle, "fields")
    extern (C) export Field[] fields()
    {
        Field[] ret;
        foreach (field; methodTable.eeClass.fields)
            ret ~= cast(Field)field;
        return ret;
    }
}