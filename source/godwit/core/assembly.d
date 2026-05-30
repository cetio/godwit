module godwit.core.assembly;

import godwit.backend.vm.assembly;
import godwit.backend.vm.ceeload;
import std.string;

public struct Assembly
{
package:
final:
    godwit.backend.vm.assembly.Assembly* assembly;

public:
    string name()
    {
        if (assembly == null || assembly.ceemodule == null || assembly.ceemodule.simpleName == null)
            return null;

        return fromStringz(assembly.ceemodule.simpleName).idup;
    }

    godwit.backend.vm.ceeload.Module* ceemodule()
    {
        if (assembly == null)
            return null;

        return assembly.ceemodule;
    }
}