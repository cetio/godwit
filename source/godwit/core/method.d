module godwit.core.method;

import godwit.backend.vm.method;
import godwit.backend.metadata;

public struct Method
{
package:
final:
    MethodDesc* methodDesc;

public:
    string name()
    {
        throw new Exception("Unimplemented");
    }

    MethodDef token()
    {
        return methodDesc.token;
    }
}