module godwit.core.field;

import godwit.backend.vm.field;
import godwit.backend.metadata;

public struct Field
{
package:
final:
    FieldDesc* fieldDesc;

public:
    FieldDef token()
    {
        return tokenFromRid(fieldDesc.rid, CorTokenType.FieldDef);
    }

    uint offsetOf()
    {
        return fieldDesc.offset;
    }
}