// I really do not like having this file, but I hate doing `import godwit;`
/// Contains all implementation flags for CoreCLR
module godwit.impl;

public:
static:
// TARGET_x64 and HOST_x64 should always be equal to eachother, or else you risk conflicts in native integer sizes.
// Everything else is able to be freely modified.

/// Default `false`.
enum DACCESS_COMPILE = false;
/// Default `false`, this is for CoreCLR debug, not C# debug.
enum DEBUG = false;
/// Default `false`.
enum MSC_VER = false;
/// Default `true`? (TBD)
enum COM_INTEROP = true;
/// Default `false`? (TBD)
enum COM_WRAPPERS = false;
/// Default `false`.
enum READYTORUN = false;
/// Default `true`.
enum TARGET_x64 = true;
/// Default `false`.
enum GCCOVER = false;
/// Default `true`.
enum TIERED_COMPILATION = true;
/// No default, defined by build settings.
enum HOST_x64 = size_t.sizeof == 8;
/// Default `false`.
enum LOGGING = false;
/// Default `false`.
enum FAT_DISPATCH_TOKENS = false;
/// Default `true`.
enum ON_STACK_REPLACEMENT = true;
/// Default `true`.
enum TYPE_EQUIVALENCE = true;
/// Default `false`.
enum CODE_VERSIONING = false;
/// Default `false`.
enum MULTICORE_JIT = false;
/// Default `false`.
enum PGO = false;
/// Default `false`.
enum HASHTABLE_PROFILE = false;
/// Default `false`.
enum EH_FUNCLETS = false;
/// Default `false`.
enum PROFILING_SUPPORTED_DATA = false;
/// Default `false`.
enum PROFILING_SUPPORTED = false;
/// Default `false`.
enum COM_INTEROP_UNMANAGED_ACTIVATION = false;
/// Default `true`.
enum HFA = true;
/// Default `false`.
enum METADATA_UPDATER = false;
/// Default `true`.
enum COLLECTIBLE_TYPES = true;