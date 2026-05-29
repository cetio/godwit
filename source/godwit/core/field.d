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
        => fieldDesc.offset;

    FieldDef token()
        => tokenFromRid(fieldDesc.rid, CorTokenType.FieldDef);
}