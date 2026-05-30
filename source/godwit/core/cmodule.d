module godwit.core.cmodule;

import godwit.backend.vm.ceeload;
import std.string;

public struct Module
{
package:
final:
    godwit.backend.vm.ceeload.Module* ceemodule;

public:
    string name()
    {
        if (ceemodule == null || ceemodule.simpleName == null)
            return null;

        return fromStringz(ceemodule.simpleName).idup;
    }
}
