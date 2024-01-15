// I really do not like having this file, but I hate doing `import godwit;`
/// Contains all implementation flags for CoreCLR
module godwit.impl;

public:
static:
enum DACCESS_COMPILE = false;
enum DEBUG = false;
enum MSC_VER = false;
enum COM_INTEROP = false;
enum COM_WRAPPERS = false;
enum READYTORUN = false;
enum TARGET_x64 = true;
enum GCCOVER = false;
enum TIERED_COMPILATION = true;
enum HOST_x64 = size_t.sizeof == 8;