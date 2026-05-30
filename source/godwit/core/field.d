module godwit.core.field;

import godwit.backend.vm.field;
import godwit.backend.metadata;
import godwit.core.reflection;

public struct Field
{
package:
final:
    FieldDesc* fieldDesc;

public:
    string name()
    {
        IMetaDataImport importer = getImporter(fieldDesc.methodTable);
        return getFieldDefName(importer, token);
    }

    uint offsetOf()
        => fieldDesc.offset;

    FieldDef token()
        => tokenFromRid(fieldDesc.rid, CorTokenType.FieldDef);

    bool valid()
        => fieldDesc != null;

    bool isStatic()
        => fieldDesc.isStatic;

    void* getValuePtr(void* target)
    {
        if (fieldDesc == null)
            return null;

        if (fieldDesc.isStatic)
            throw new Exception("Static field access is not yet implemented");

        return cast(void*)(cast(ubyte*)target + fieldDesc.offset);
    }

    int getInt(void* target)
    {
        void* ptr = getValuePtr(target);
        return ptr != null ? *cast(int*)ptr : 0;
    }

    void setInt(void* target, int value)
    {
        void* ptr = getValuePtr(target);
        if (ptr != null)
            *cast(int*)ptr = value;
    }

    bool getBool(void* target)
    {
        void* ptr = getValuePtr(target);
        return ptr != null ? *cast(bool*)ptr : false;
    }

    void setBool(void* target, bool value)
    {
        void* ptr = getValuePtr(target);
        if (ptr != null)
            *cast(bool*)ptr = value;
    }

    float getFloat(void* target)
    {
        void* ptr = getValuePtr(target);
        return ptr != null ? *cast(float*)ptr : 0.0f;
    }

    void setFloat(void* target, float value)
    {
        void* ptr = getValuePtr(target);
        if (ptr != null)
            *cast(float*)ptr = value;
    }

    void* getValue(void* target)
    {
        return getValuePtr(target);
    }

    void setValue(void* target, void* value)
    {
        void* fieldAddr = getValuePtr(target);
        if (fieldAddr != null)
            *cast(size_t*)fieldAddr = cast(size_t)value;
    }
}