module kingfisher;

import core.sys.windows.windows;
import core.sys.windows.dll;

mixin SimpleDllMain;

extern (C) export void Initialize()