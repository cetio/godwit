module godwit.core.type;

import godwit.backend.vm.methodtable;
import godwit.core.method;
import godwit.core.field;
import godwit.backend.metadata;
import godwit.backend.vm.eeclass;
import godwit.core.reflection;

public struct Type
{
public:
final:
    MethodTable* methodTable;

public:
    bool valid()
        => methodTable != null;

    string name()
    {
        IMetaDataImport importer = getImporter(methodTable);
        return getTypeDefName(importer, token);
    }

    uint sizeOf()
        => methodTable.baseSize - cast(uint)(2 * size_t.sizeof);

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
        => methodTable.token;

    Method findMethod(string name, bool skipGeneric = false)
    {
        Type current = this;
        while (current.valid)
        {
            foreach (method; current.methods)
            {
                if (method.name == name)
                {
                    if (skipGeneric && method.isGenericMethodDefinition)
                        continue;
                    return method;
                }
            }
            if (current.methodTable.parentMethodTable == null)
                break;
            current = cast(Type)current.methodTable.parentMethodTable;
        }
        return Method.init;
    }

    Field findField(string name)
    {
        Type current = this;
        while (current.valid)
        {
            foreach (field; current.fields)
            {
                if (field.name == name)
                    return field;
            }
            if (current.methodTable.parentMethodTable == null)
                break;
            current = cast(Type)current.methodTable.parentMethodTable;
        }
        return Field.init;
    }
}