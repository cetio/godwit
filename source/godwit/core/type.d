module godwit.type;

import godwit.backend.vm.methodtable;
import godwit.method;
import godwit.field;
import godwit.backend.vm.eeclass;

public class Type
{
package:
final:
    MethodTable* methodTable;

    this(MethodTable* methodTable)
    {
        this.methodTable = methodTable;
    }

public:
    string name()
    {
        throw new Exception("Unimplemented");
    }

    uint sizeOf()
    {
        return methodTable.baseSize;
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
            ret ~= new Field(field);
        import std.stdio;
        writeln(*methodTable.eeClass);
        return ret;
    }
}