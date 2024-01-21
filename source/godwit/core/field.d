module godwit.core.field;

import godwit.backend.vm.field;
import godwit.backend.metadata;

public struct Field
{
package:
final:
    FieldDesc* fieldDesc;

public:
    string name()
    {
        throw new Exception("Unimplemented");
    }

    uint offsetOf()
    {
        return fieldDesc.offset;
    }

    FieldDef token()
    {
        return tokenFromRid(fieldDesc.rid, CorTokenType.FieldDef);
    }
}