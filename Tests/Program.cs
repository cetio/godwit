using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

#if DEBUG
[DllImport(@"C:\Users\stake\Documents\source\repos\godwit\godwit.dll")]
#else
[DllImport("godwit.dll")]
#endif
static extern unsafe void initialize(nint pDOM);

unsafe
{
    var handle = typeof(TestStructure).Module.ModuleHandle;
    initialize(*(nint*)Unsafe.AsPointer(ref handle));
    /*int a = 1;
    float b = 3.1415f;
    TestStructure c = new TestStructure(1, 2, 3, 4, 5, 6);
    int d = 88;
    int e = -1;
    int f = -2;
    ulong ret = InvokeVTEx(typeof(Program).GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static)[2].MethodHandle.GetFunctionPointer(), pargs, pseries);
    Console.WriteLine(Unsafe.As<ulong, int>(ref ret));*/
}

static unsafe int Testw(int a, float b, TestStructure c, int d, int e, int f)
{
    Console.WriteLine($"wahoo! {a} {b} {c} {d} {e} {f}");
    return 33;
}

struct TestStructure
{
    static long st;
    int a;
    int b;
    int c;
    nint d;
    double e;
    int f;

    public TestStructure(int a, int b, int c, nint d, double e, int f)
    {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.e = e;
        this.f = f;
    }

    public override string ToString()
    {
        return $"{a}{b}{c}{d}{e}{f}";
    }
}

@property godwit.ceeload.Module* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(void)* next() { return m_next; }
@property void** table() { return m_table; }
@property uint count() { return m_count; }
@property void* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(uint) typeRefToMethodTableMap() { return m_typeRefToMethodTableMap; }
@property godwit.ceeload.LookupMap!(godwit.ceeload.Module) manifestModuleRefsMap() { return m_manifestModuleRefsMap; }
@property godwit.ceeload.LookupMap!(void) memberRefMap() { return m_memberRefMap; }
@property godwit.crst.CrstExplicitInit lookupTableCrst() { return m_lookupTableCrst; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.ceeload.VASigCookieBlock* next() { return m_next; }
@property uint numCookies() { return m_numCookies; }
@property godwit.ceeload.VASigCookie[] cookies() { return m_cookies; }
@property uint sizeOfArgs() { return m_sizeOfArgs; }
@property ubyte* ndirectILStub() { return m_ndirectILStub; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.siginfo.Signature signature() { return m_signature; }
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable)* next() { return m_next; }
@property godwit.methodtable.MethodTable** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.methodtable.MethodTable* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.method.MethodDesc)* next() { return m_next; }
@property godwit.method.MethodDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.method.MethodDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.field.FieldDesc)* next() { return m_next; }
@property godwit.field.FieldDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.field.FieldDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.typedesc.TypeVarTypeDesc)* next() { return m_next; }
@property godwit.typedesc.TypeVarTypeDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.typedesc.TypeVarTypeDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(ulong)* next() { return m_next; }
@property ulong** table() { return m_table; }
@property uint count() { return m_count; }
@property ulong* supportedFlags() { return m_supportedFlags; }
@property char* simpleName() { return m_simpleName; }
@property godwit.peassembly.PEAssembly* peAssembly() { return m_peAssembly; }
@property godwit.ceeload.Module.TransientFlags transientFlags() { return m_transientFlags; }
@property godwit.ceeload.Module.PersistentFlags persistentFlags() { return m_persistentFlags; }
@property godwit.ceeload.VASigCookieBlock* vaSigCookieBlock() { return m_vaSigCookieBlock; }
@property godwit.assembly.Assembly* assembly() { return m_assembly; }
@property godwit.crst.CrstExplicitInit crst() { return m_crst; }
@property godwit.crst.CrstExplicitInit fixupCrst() { return m_fixupCrst; }
@property void* symUnmanagedReader() { return m_symUnmanagedReader; }
@property godwit.crst.CrstExplicitInit symUnmanagedReaderCrst() { return m_symUnmanagedReaderCrst; }
@property void* streamSym() { return m_streamSym; }
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable) typeDefToMethodTableMap() { return m_typeDefToMethodTableMap; }   
@property godwit.ceeload.LookupMap!(godwit.method.MethodDesc) methodDefToDescMap() { return m_methodDefToDescMap; }
@property godwit.ceeload.LookupMap!(godwit.field.FieldDesc) fieldDefToDescMap() { return m_fieldDefToDescMap; }
@property godwit.ceeload.LookupMap!(godwit.typedesc.TypeVarTypeDesc) genericParamToDescMap() { return m_genericParamToDescMap; }      
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable) genericTypeDefToCanonMethodTableMap() { return m_genericTypeDefToCanonMethodTableMap; }
@property godwit.ceeload.LookupMap!(ulong) methodDefToPropertyInfoMap() { return m_methodDefToPropertyInfoMap; }
@property godwit.ilstubcache.ILStubCache* ilStubCache() { return m_ilStubCache; }
@property uint defaultDllImportSearchPathsAttributeValue() { return m_defaultDllImportSearchPathsAttributeValue; }
@property godwit.classhash.EEClassHashTable* availableClasses() { return m_availableClasses; }
@property godwit.typehash.EETypeHashTable* availableParamTypes() { return m_availableParamTypes; }
@property godwit.crst.CrstExplicitInit instMethodHashTableCrst() { return m_instMethodHashTableCrst; }
@property godwit.instmethhash.InstMethodHashTable* instMethodHashTable() { return m_instMethodHashTable; }
@property uint debuggerJMCProbeCount() { return m_debuggerJMCProbeCount; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.typehandle.TypeHandle typeHandle() { return m_typeHandle; }
@property godwit.typekey.TypeKey typeKey() { return m_typeKey; }
@property int waitCount() { return m_waitCount; }
@property godwit.collections.state.HResult hresult() { return m_hresult; }
@property godwit.ex.EXException* exception() { return m_exception; }
@property bool lockAcquired() { return m_lockAcquired; }
@property godwit.pendingload.TableEntry* next() { return m_next; }
@property uint hashValue() { return m_hashValue; }
@property godwit.pendingload.PendingTypeLoadEntry* data() { return m_data; }
@property godwit.pendingload.TableEntry** buckets() { return m_buckets; }
@property uint numBuckets() { return m_numBuckets; }
@property godwit.pendingload.PendingTypeLoadTable* unresolvedClassHash() { return m_unresolvedClassHash; }
@property godwit.crst.CrstExplicitInit unresolvedClassLock() { return m_unresolvedClassLock; }
@property godwit.crst.CrstExplicitInit availableClassLock() { return m_availableClassLock; }
@property godwit.crst.CrstExplicitInit availableTypesLock() { return m_availableTypesLock; }
@property int unhashedModules() { return m_unhashedModules; }
@property godwit.assembly.Assembly* assembly() { return m_assembly; }
@property godwit.appdomain.BaseDomain* baseDomain() { return m_baseDomain; }
@property godwit.clsload.ClassLoader* classLoader() { return m_classLoader; }
@property godwit.method.MethodDesc* entryPoint() { return m_entryPoint; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.peassembly.PEAssembly* peAssembly() { return m_peAssembly; }
@property godwit.assembly.FriendAssemblyDescriptor* friendAssemblyDescriptor() { return m_friendAssemblyDescriptor; }
@property bool isDynamic() { return m_isDynamic; }
@property bool isCollectible() { return m_isCollectible; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property ubyte* itypeLib() { return m_itypeLib; }
@property uint interopAttribStatus() { return m_interopAttribStatus; }
@property godwit.corhdr.DebuggerAssemblyControlFlags debuggerFlags() { return m_debuggerFlags; }
@property bool isTerminated() { return m_isTerminated; }
@property godwit.arraylist.ArrayList fullAccessFriendAssemblies() { return m_fullAccessFriendAssemblies; }
@property godwit.arraylist.ArrayList subjectAssemblies() { return m_subjectAssemblies; }
@property int refCount() { return m_refCount; }
@property wchar* simpleName() { return m_simpleName; }
@property wchar* ilFileName() { return m_ilFileName; }
@property wchar* niFileName() { return m_niFileName; }
@property godwit.sbuffer.SString assemblyNameOrPath() { return m_assemblyNameOrPath; }
@property godwit.collections.state.HResult bindingResult() { return m_bindingResult; }
Error dmd.EXE failed with exit code 1.

 *  The terminal process "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command & 'C:\D\dmd-2.106.0\windows\bin64\dub.exe' 'build' '--compiler=dmd.EXE' '-a=x86_64' '-b=debug' '-c=library'" terminated with exit code: 1. 
 *  Terminal will be reused by tasks, press any key to close it. 

 *  Executing task: & 'C:\D\dmd-2.106.0\windows\bin64\dub.exe' 'build' '--compiler=dmd.EXE' '--arch=x86_64' '--build=debug' '--config=library' 

    Starting Performing "debug" build using dmd.EXE for x86_64.
    Building godwit ~master: building configuration [library]
@property ulong size() { return m_size; }
@property ulong allocSize() { return m_allocSize; }
@property godwit.sbuffer.SBuffer.State flags() { return m_flags; }
@property ubyte* buffer() { return m_buffer; }
@property wchar* asString() { return m_asString; }
@property uint virtualAddress() { return m_virtualAddress; }
@property uint size() { return m_size; }
@property uint beginAddress() { return m_beginAddress; }
@property uint unwindData() { return m_unwindData; }
@property uint* slots() { return m_slots; }
@property godwit.method.MethodDesc* implement() { return m_implement; }
@property godwit.methodtable.MethodTable* declaringMethodTable() { return m_declaringMethodTable; }
@property godwit.method.MethodDescChunk* nextChunk() { return m_nextChunk; }
@property ubyte size() { return m_size; }
@property ubyte count() { return m_count; }
@property godwit.method.MethodDescChunk.ChunkFlags chunkFlags() { return m_chunkFlags; }
@property godwit.method.MethodDesc methodDesc() { return m_methodDesc; }
@property godwit.method.MethodDesc.CodeFlags codeFlags() { return m_codeFlags; }
@property ubyte chunkIndex() { return m_chunkIndex; }
@property ubyte methodIndex() { return m_methodIndex; }
@property ushort slotNumber() { return m_slotNumber; }
@property godwit.method.MethodDesc.MethodClassification classification() { return m_classification; }
@property godwit.method.MethodDesc.MethodProperties properties() { return m_properties; }
@property void* fn() { return m_fn; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property ubyte* dictLayout() { return m_dictLayout; }
@property godwit.method.MethodDesc* wrappedMethodDesc() { return m_wrappedMethodDesc; }
@property ubyte* perInstInfo() { return m_perInstInfo; }
@property godwit.method.InstantiatedMethodDesc.InstantiationFlags instFlags() { return m_instFlags; }
@property int genericsCount() { return m_genericsCount; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property void* sig() { return m_sig; }
@property uint count() { return m_count; }
@property uint extendedFlags() { return m_extendedFlags; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property uint ecallId() { return m_ecallId; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property char* methodName() { return m_methodName; }
@property ubyte* resolver() { return m_resolver; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property void* directTarget() { return m_directTarget; }
@property char* entrypointName() { return m_entrypointName; }
@property char* libName() { return m_libName; }
@property uint ecallId() { return m_ecallId; }
@property godwit.method.NDirectWriteableData* writeableData() { return m_writeableData; }
@property godwit.method.NDirectImportThunkGlue* importThunkGlue() { return m_importThunkGlue; }
@property uint defaultDllSearchAttr() { return m_defaultDllSearchAttr; }
@property godwit.method.NDirectMethodDesc.BindingFlags bindingFlags() { return m_bindingFlags; }
@property void* comPlusCallInfo() { return m_comPlusCallInfo; }
@property uint mb() { return m_mb; }
@property bool isfStatic() { return m_isfStatic; }
@property bool isfThreadLocal() { return m_isfThreadLocal; }
@property bool isfRVA() { return m_isfRVA; }
@property godwit.field.FieldDesc.Protection protection() { return m_protection; }
@property uint offset() { return m_offset; }
@property godwit.corhdr.CorElementType elemType() { return m_elemType; }
@property ubyte* sig() { return m_sig; }
@property uint len() { return m_len; }
@property ubyte* ilStub() { return m_ilStub; }
@property godwit.method.MethodDesc* methodDesc() { return m_methodDesc; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.siginfo.Signature sig() { return m_sig; }
@property uint refCount() { return m_refCount; }
@property godwit.stub.Stub.CodeFlags codeFlags() { return m_codeFlags; }
@property uint numCodeBytes() { return m_numCodeBytes; }
@property ushort patchOffset() { return m_patchOffset; }
@property godwit.method.MethodDesc* instantiatedMethod() { return m_instantiatedMethod; }
@property godwit.objects.ObjHeader.SyncBlockFlags flags() { return m_flags; }
@property godwit.objects.ObjHeader objHeader() { return m_objHeader; }
@property godwit.methodtable.MethodTable* methodTable() { return m_methodTable; }
@property ubyte data() { return m_data; }
@property ubyte* vtable() { return m_vtable; }
@property godwit.methodtable.MethodTable* wrappedMethodTable() { return m_wrappedMethodTable; }
@property godwit.method.MethodDesc* wrappedMethodDesc() { return m_wrappedMethodDesc; }
@property ubyte* mlHeader() { return m_mlHeader; }
@property ubyte* mlCode() { return m_mlCode; }
@property godwit.method.MethodDescChunk* methodDescChunk() { return m_methodDescChunk; }
@property ubyte* ilCode() { return m_ilCode; }
@property ubyte* extraInfo() { return m_extraInfo; }
@property godwit.methodtable.MethodTable* interfaceMethodTable() { return m_interfaceMethodTable; }
@property ushort mtStart() { return m_mtStart; }
@property ushort count() { return m_count; }
@property ushort vtStart() { return m_vtStart; }
@property godwit.eeclass.SparseVTableEntry* entryMapList() { return m_entryMapList; }
@property ushort numMapEntries() { return m_numMapEntries; }
@property ushort numAllocated() { return m_numAllocated; }
@property ushort lastUsedIndex() { return m_lastUsedIndex; }
@property ushort vtSlot() { return m_vtSlot; }
@property ushort mtSlot() { return m_mtSlot; }
@property uint managedSize() { return m_managedSize; }
@property ubyte largestMemberAlignmentReq() { return m_largestMemberAlignmentReq; }
@property godwit.eeclass.LayoutInfo.LayoutFlags layoutFlags() { return m_layoutFlags; }
@property ubyte packingSize() { return m_packingSize; }
@property ubyte alignmentReq() { return m_alignmentReq; }
@property bool isMarshalable() { return m_isMarshalable; }
@property ushort size() { return m_size; }
@property uint numFields() { return m_numFields; }
@property godwit.eeclass.NativeFieldDescriptor* nativeFieldDescriptor() { return m_nativeFieldDescriptor; }
@property godwit.field.FieldDesc* fieldDesc() { return m_fieldDesc; }
@property godwit.methodtable.MethodTable* nestedType() { return m_nestedType; }
@property uint numNestedElements() { return m_numNestedElements; }
@property uint nativeSize() { return m_nativeSize; }
@property uint numFieldElements() { return m_numFieldElements; }
@property uint offset() { return m_offset; }
@property godwit.eeclass.NativeFieldDescriptor.NativeFieldCategory category() { return m_category; }
@property godwit.methodtable.MethodTable* methodTable() { return m_methodTable; }
@property godwit.typehandle.TypeHandle arg() { return m_arg; }
@property long exposedClassObject() { return m_exposedClassObject; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property uint mdToken() { return m_mdToken; }
@property uint numConstraints() { return m_numConstraints; }
@property godwit.typehandle.TypeHandle* constraints() { return m_constraints; }
@property long exposedClassObject() { return m_exposedClassObject; }
@property uint argMDToken() { return m_argMDToken; }
@property uint index() { return m_index; }
@property uint numArgs() { return m_numArgs; }
@property uint callingConv() { return m_callingConv; }
@property godwit.typehandle.TypeHandle[] types() { return m_types; }
@property godwit.typedesc.TypeDesc* typeDesc() { return m_typeDesc; }
@property godwit.typedesc.ParamTypeDesc* paramTypeDesc() { return m_paramTypeDesc; }
@property godwit.typedesc.TypeVarTypeDesc* typeVarTypeDesc() { return m_typeVarTypeDesc; }
@property godwit.typedesc.FnPtrTypeDesc* fnPtrTypeDesc() { return m_fnPtrTypeDesc; }
@property ubyte* dictLayout() { return m_dictLayout; }
@property ubyte* varianceInfo() { return m_varianceInfo; }
@property godwit.eeclass.SparseVTableMap* sparseVTableMap() { return m_sparseVTableMap; }
@property godwit.typehandle.TypeHandle coClass() { return m_coClass; }
@property uint moduleDynamicID() { return m_moduleDynamicID; }
@property ubyte requiredFieldAlignment() { return m_requiredFieldAlignment; }
@property godwit.methodtable.GuidInfo* guidInfo() { return m_guidInfo; }
@property godwit.eeclass.OptionalFields* optionalFields() { return m_optionalFields; }
@property godwit.methodtable.MethodTable* methodTable() { return m_methodTable; }
@property godwit.field.FieldDesc* fieldDescList() { return m_fieldDescList; }
@property godwit.method.MethodDescChunk* methodDescChunk() { return m_methodDescChunk; }
@property uint* delegateObjectHandle() { return m_delegateObjectHandle; }
@property godwit.corhdr.CorInterfaceType corInterfaceType() { return m_corInterfaceType; }
@property godwit.eeclass.CCWTemplate* ccwTemplate() { return m_ccwTemplate; }
@property godwit.eeclass.EEClass.TypeAttributes typeAttributes() { return m_typeAttributes; }
@property godwit.eeclass.EEClass.VMFlags vmFlags() { return m_vmFlags; }
@property godwit.corhdr.CorElementType corElementType() { return m_corElementType; }
@property bool fieldsArePacked() { return m_fieldsArePacked; }
@property ubyte fixedEEClassFields() { return m_fixedEEClassFields; }
@property ubyte baseSizePadding() { return m_baseSizePadding; }
@property uint rank() { return m_rank; }
@property godwit.corhdr.CorElementType elemType() { return m_elemType; }
@property godwit.stub.Stub* staticCallStub() { return m_staticCallStub; }
@property godwit.eeclass.LayoutInfo layoutInfo() { return m_layoutInfo; }
@property godwit.stub.Stub* instRetBuffCallStub() { return m_instRetBuffCallStub; }
@property godwit.eeclass.NativeLayoutInfo* nativeLayoutInfo() { return m_nativeLayoutInfo; }
@property godwit.method.MethodDesc* invokeMethod() { return m_invokeMethod; }
@property godwit.stub.Stub* multiCastInvokeStub() { return m_multiCastInvokeStub; }
@property godwit.stub.Stub* wrapperDelegateInvokeStub() { return m_wrapperDelegateInvokeStub; }
@property godwit.stub.UMThunkMarshInfo* umThunkMarshInfo() { return m_umThunkMarshInfo; }
@property godwit.method.MethodDesc* beginInvokeMethod() { return m_beginInvokeMethod; }
@property godwit.method.MethodDesc* endInvokeMethod() { return m_endInvokeMethod; }
@property ubyte* marshalStub() { return m_marshalStub; }
@property ubyte*[] entries() { return m_entries; }
@property uint nptrs() { return m_nptrs; }
@property uint skip() { return m_skip; }
@property ulong seriesSize() { return m_seriesSize; }
@property godwit.gcdesc.VTSeriesItem vtItems() { return m_vtItems; }
@property ulong startOffset() { return m_startOffset; }
@property godwit.methodtable.WriteableData.WriteableFlags writeableFlags() { return m_writeableFlags; }
@property long exposedClassObject() { return m_exposedClassObject; }
@property std.uuid.UUID guid() { return m_guid; }
@property bool generatedFromName() { return m_generatedFromName; }
@property godwit.methodtable.MethodTable.TypeFlags typeFlags() { return m_typeFlags; }
@property ushort componentSize() { return m_componentSize; }
@property godwit.methodtable.MethodTable.GenericFlags genericFlags() { return m_genericFlags; }
@property uint baseSize() { return m_baseSize; }
@property godwit.methodtable.MethodTable.InterfaceFlags interfaceFlags() { return m_interfaceFlags; }
@property ushort mdToken() { return m_mdToken; }
@property ushort numVirtuals() { return m_numVirtuals; }
@property ushort numInterfaces() { return m_numInterfaces; }
@property godwit.methodtable.MethodTable* parentMethodTable() { return m_parentMethodTable; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.methodtable.WriteableData* writeableData() { return m_writeableData; }
@property ubyte rawTypeKind() { return m_rawTypeKind; }
@property godwit.eeclass.EEClass* eeClass() { return m_eeClass; }
@property godwit.methodtable.MethodTable* canonMethodTable() { return m_canonMethodTable; }
@property godwit.genericdict.Dictionary* perInstInfo() { return m_perInstInfo; }
@property godwit.methodtable.MethodTable* elementMethodTable() { return m_elementMethodTable; }
@property ubyte* multiPurposeSlot1() { return m_multiPurposeSlot1; }
@property godwit.methodtable.MethodTable* interfaceMap() { return m_interfaceMap; }
@property ubyte* multiPurposeSlot2() { return m_multiPurposeSlot2; }
@property godwit.typehandle.TypeHandle* args() { return m_args; }
@property uint numArgs() { return m_numArgs; }
@property godwit.typehandle.Instantiation classInst() { return m_classInst; }
@property godwit.typehandle.Instantiation methodInst() { return m_methodInst; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.typectxt.SigTypeContext typeContext() { return m_typeContext; }
@property ubyte* start() { return m_start; }
@property ubyte* walk() { return m_walk; }
@property ubyte* lastType() { return m_lastType; }
@property ubyte* retType() { return m_retType; }
@property uint numArgs() { return m_numArgs; }
@property uint curArg() { return m_curArg; }
@property godwit.corhdr.CorElementType corRetType() { return m_corRetType; }
@property godwit.siginfo.MetaSig.Flags flags() { return m_flags; }
@property ubyte callingConv() { return m_callingConv; }
@property godwit.crst.CrstBase.ReservedFlags flags() { return m_flags; }
@property int refCount() { return m_refCount; }
@property godwit.peimage.PEImage* owner() { return m_owner; }
@property void** fileView() { return m_fileView; }
@property long* fileMap() { return m_fileMap; }
@property godwit.corhdr.RuntimeFunction* exceptionDir() { return m_exceptionDir; }
@property ulong[16] imageParts() { return m_imageParts; }
@property long* hmodule() { return m_hmodule; }
@property void** loadedFile() { return m_loadedFile; }
@property long size() { return m_size; }
@property long offset() { return m_offset; }
@property long uncompressedSize() { return m_uncompressedSize; }
@property godwit.sbuffer.SString path() { return m_path; }
@property bool function(const(char*), long*, long*, long*) probe() { return m_probe; }
@property godwit.sbuffer.SString basePath() { return m_basePath; }
@property uint basePathLen() { return m_basePathLen; }
@property int rwLock() { return m_rwLock; }
@property int spinCount() { return m_spinCount; }
@property bool writerWaiting() { return m_writerWaiting; }
@property godwit.sbuffer.SString path() { return m_path; }
@property uint pathHash() { return m_pathHash; }
@property int refCount() { return m_refCount; }
@property bool inHashMap() { return m_inHashMap; }
@property godwit.bundle.BundleFileLocation bundleFileLocation() { return m_bundleFileLocation; }
@property long fileHandle() { return m_fileHandle; }
@property uint peKind() { return m_peKind; }
@property uint machine() { return m_machine; }
@property godwit.sbuffer.SString moduleFileNameHintUsedByDac() { return m_moduleFileNameHintUsedByDac; }
@property godwit.simplerwlock.SimpleRWLock* layoutLock() { return m_layoutLock; }
@property godwit.peimagelayout.PEImageLayout*[2] layouts() { return m_layouts; }
@property ubyte* mdImport() { return m_mdImport; }
@property godwit.readytorun.ReadyToRunCoreHeader.Flags flags() { return m_flags; }
@property uint numSections() { return m_numSections; }
@property uint signature() { return m_signature; }
@property ushort major() { return m_major; }
@property ushort minor() { return m_minor; }
@property godwit.readytorun.ReadyToRunCoreHeader coreHeader() { return m_coreHeader; }
@property godwit.corhdr.ImageDataDirectory section() { return m_section; }
@property godwit.readytorun.ReadyToRunImportSection.SectionFlags flags() { return m_flags; }
@property godwit.readytorun.ReadyToRunImportSection.SectionType type() { return m_type; }
@property ubyte entrySize() { return m_entrySize; }
@property uint signatures() { return m_signatures; }
@property uint auxData() { return m_auxData; }
@property godwit.hash.Compare* compare() { return m_compare; }
@property ulong primeIndex() { return m_primeIndex; }
@property godwit.hash.Bucket* buckets() { return m_buckets; }
@property ulong prevSlotsInUse() { return m_prevSlotsInUse; }
@property ulong inserts() { return m_inserts; }
@property ulong deletes() { return m_deletes; }
@property godwit.hash.HashMap.Mode mode() { return m_mode; }
@property uint*[4] keys() { return m_keys; }
@property uint*[4] values() { return m_values; }
@property bool function(uint*, uint*) fn() { return m_fn; }
source\collections\state.d-mixin-167(167,42): Error: basic type expected, not `extern`
source\collections\state.d-mixin-167(167,42): Error: found `extern` when expecting `)`
source\collections\state.d-mixin-167(167,48): Error: semicolon expected following function declaration, not `(`
source\collections\state.d-mixin-167(167,48): Error: declaration expected, not `(`
source\collections\state.d-mixin-167(167,99): Error: declaration expected, not `return`
source\vm\hash.d(67,5): Error: mixin `godwit.hash.Compare.accessors!()` error instantiating
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.inlinetracking.ZapInlineeRecord* inlineeIndex() { return m_inlineeIndex; }
@property uint inlineeIndexSize() { return m_inlineeIndexSize; }
@property ubyte* inlinersBuffer() { return m_inlinersBuffer; }
@property uint inlinersBufferSize() { return m_inlinersBufferSize; }
@property uint key() { return m_key; }
@property uint offset() { return m_offset; }
@property godwit.peimagelayout.PEImageLayout* layout() { return m_layout; }
@property godwit.readytorun.ReadyToRunCoreHeader* coreHeader() { return m_coreHeader; }
@property bool forbidLoadILBodyFixups() { return m_forbidLoadILBodyFixups; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.ceeload.ModuleBase* nativeManifestModule() { return m_nativeManifestModule; }
@property godwit.readytorun.ReadyToRunHeader* header() { return m_header; }
@property bool isComponentAssembly() { return m_isComponentAssembly; }
@property godwit.nativeimage.NativeImage* nativeImage() { return m_nativeImage; }
@property godwit.readytoruninfo.ReadyToRunInfo* compositeInfo() { return m_compositeInfo; }
@property godwit.readytoruninfo.ReadyToRunCoreInfo component() { return m_component; }
@property godwit.readytoruninfo.ReadyToRunCoreInfo* composite() { return m_composite; }
@property godwit.corhdr.RuntimeFunction* runtimeFunctions() { return m_runtimeFunctions; }
@property uint numRuntimeFunctions() { return m_numRuntimeFunctions; }
@property uint* hotColdMap() { return m_hotColdMap; }
@property uint numHotColdMap() { return m_numHotColdMap; }
@property godwit.corhdr.ImageDataDirectory* sectionDelayLoadMethodCallThunks() { return m_sectionDelayLoadMethodCallThunks; }
@property godwit.readytorun.ReadyToRunImportSection* importSections() { return m_importSections; }
@property uint numImportSections() { return m_numImportSections; }
@property bool readyToRunCodeDisabled() { return m_readyToRunCodeDisabled; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.hash.HashMap* entrypointToMethodDescMap() { return m_entrypointToMethodDescMap; }
@property godwit.inlinetracking.PersistentInlineTrackingMapR2R* persistentInlineTrackingMap() { return m_persistentInlineTrackingMap; }
@property godwit.inlinetracking.PersistentInlineTrackingMapR2R* crossModulePersistentInlineTrackingMap() { return m_crossModulePersistentInlineTrackingMap; }
@property godwit.readytoruninfo.ReadyToRunInfo* nextR2RForUnrelatedCode() { return m_nextR2RForUnrelatedCode; }
@property godwit.nativeimage.AssemblyNameIndex* table() { return m_table; }
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property char* fileName() { return m_fileName; }
@property godwit.assemblybinder.AssemblyBinder* assemblyBinder() { return m_assemblyBinder; }
@property godwit.readytoruninfo.ReadyToRunInfo* readyToRunInfo() { return m_readyToRunInfo; }
@property void* manifestMetadata() { return m_manifestMetadata; }
@property godwit.peimagelayout.PEImageLayout* imageLayout() { return m_imageLayout; }
@property godwit.assembly.Assembly** nativeMetadataAssemblyRefMap() { return m_nativeMetadataAssemblyRefMap; }
@property godwit.ceeload.ModuleBase* nativeManifestModule() { return m_nativeManifestModule; }
@property godwit.corhdr.ImageDataDirectory* componentAssemblies() { return m_componentAssemblies; }
@property uint componentAssemblyCount() { return m_componentAssemblyCount; }
@property uint manifestAssemblyCount() { return m_manifestAssemblyCount; }
@property godwit.shash.SHash!(godwit.nativeimage.AssemblyNameIndex, uint) assemblySimpleNameToIndexMap() { return m_assemblySimpleNameToIndexMap; }
@property godwit.crst.Crst eagerFixupsLock() { return m_eagerFixupsLock; }
@property bool eagerFixupsHaveRun() { return m_eagerFixupsHaveRun; }
@property bool readyToRunCodeDisabled() { return m_readyToRunCodeDisabled; }
@property char* name() { return m_name; }
@property int index() { return m_index; }
@property godwit.assemblybinder.SimpleNameToMVIDAndAssembly* table() { return m_table; }
source\collections\state.d-mixin-166(166,62): Deprecation: module godwit.assemblybinder is not accessible here, perhaps add 'static import godwit.assemblybinder;'
source\collections\state.d-mixin-167(167,62): Deprecation: module godwit.assemblybinder is not accessible here, perhaps add 'static import godwit.assemblybinder;'
source\collections\state.d-mixin-167(167,62): Deprecation: module godwit.assemblybinder is not accessible here, perhaps add 'static import godwit.assemblybinder;'
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property uint major() { return m_major; }
@property uint minor() { return m_minor; }
@property uint build() { return m_build; }
@property uint revision() { return m_revision; }
@property godwit.sbuffer.SString simpleName() { return m_simpleName; }
@property godwit.assemblyversion.AssemblyVersion asmVersion() { return m_asmVersion; }
@property godwit.sbuffer.SString cultureOrLanguage() { return m_cultureOrLanguage; }
@property godwit.sbuffer.SBuffer publicKeyOrTokenBlob() { return m_publicKeyOrTokenBlob; }
@property godwit.assemblyidentity.AssemblyIdentity.PEKind cpuArchitecture() { return m_cpuArchitecture; }
@property godwit.assemblyidentity.AssemblyIdentity.AssemblyContentType contentType() { return m_contentType; }
@property godwit.assemblyidentity.AssemblyIdentity.IdentityFlags identityFlags() { return m_identityFlags; }
@property int refCount() { return m_refCount; }
@property bool isDefinition() { return m_isDefinition; }
@property godwit.codeversioning.NativeCodeVersion.StorageKind storageKind() { return m_storageKind; }
@property godwit.codeversioning.NativeCodeVersionNode* versionNode() { return m_versionNode; }
@property godwit.method.MethodDesc* methodDesc() { return m_methodDesc; }
@property void* nativeCode() { return m_nativeCode; }
@property godwit.method.MethodDesc* methodDesc() { return m_methodDesc; }
@property long parentId() { return m_parentId; }
@property godwit.codeversioning.NativeCodeVersionNode* next() { return m_next; }
@property uint nativeCodeVersionId() { return m_nativeCodeVersionId; }
@property godwit.codeversioning.NativeCodeVersionNode.OptimizationTier optTier() { return m_optTier; }
@property bool preemptiveGCDisabled() { return m_preemptiveGCDisabled; }
@property uint*[16] allocContext() { return m_allocContext; }
@property godwit.gcenv.Thread* next() { return m_next; }
@property godwit.gcenv.Thread* holdingThread() { return m_holdingThread; }
@property godwit.loaderheap.LoaderHeapBlock* next() { return m_next; }
@property void* virtualAddress() { return m_virtualAddress; }
@property ulong virtualSize() { return m_virtualSize; }
@property bool releaseMem() { return m_releaseMem; }
@property godwit.loaderheap.LoaderHeapBlock* firstBlock() { return m_firstBlock; }
@property ubyte* allocPtr() { return m_allocPtr; }
@property ubyte* endCommittedRegion() { return m_endCommittedRegion; }
@property ubyte* endReservedRegion() { return m_endReservedRegion; }
@property uint reserveBlockSize() { return m_reserveBlockSize; }
@property uint commitBlockSize() { return m_commitBlockSize; }
@property uint granularity() { return m_granularity; }
@property uint* rangeList() { return m_rangeList; }
@property ulong totalAlloc() { return m_totalAlloc; }
@property godwit.loaderheap.UnlockedLoaderHeap.HeapKind kind() { return m_kind; }
@property long* firstFreeBlock() { return m_firstFreeBlock; }
@property godwit.loaderheap.LoaderHeapBlock reservedBlock() { return m_reservedBlock; }
@property bool explicitControl() { return m_explicitControl; }
@property void* critSec() { return m_critSec; }
@property void* block() { return m_block; }
@property ulong size() { return m_size; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.codeman.FreeBlock* freeBlocks() { return m_freeBlocks; }
@property godwit.codeman.CodeFragmentHeap.StubBlockKind kind() { return m_kind; }
@property godwit.crst.Crst crst() { return m_crst; }
@property byte[16] data() { return m_data; }
@property godwit.precode.Precode** table() { return m_table; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.precode is not accessible here, perhaps add 'static import godwit.precode;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.precode is not accessible here, perhaps add 'static import godwit.precode;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.precode is not accessible here, perhaps add 'static import godwit.precode;'
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property godwit.crst.Crst hashTableCrst() { return m_hashTableCrst; }
@property godwit.shash.SHash!(godwit.precode.Precode*, uint) hashTable() { return m_hashTable; }
@property godwit.memorypool.PoolElement* next() { return m_next; }
@property godwit.memorypool.PoolBlock* next() { return m_next; }
@property godwit.memorypool.PoolElement* elementsEnd() { return m_elementsEnd; }
@property godwit.memorypool.PoolElement[] elements() { return m_elements; }
@property ulong elementSize() { return m_elementSize; }
@property ulong growCount() { return m_growCount; }
@property godwit.memorypool.PoolBlock* blocks() { return m_blocks; }
@property godwit.memorypool.PoolElement* freeList() { return m_freeList; }
@property godwit.eehash.EEHashEntry* next() { return m_next; }
@property uint hashValue() { return m_hashValue; }
@property void* data() { return m_data; }
@property ubyte key() { return m_key; }
@property godwit.eehash.EEHashEntry* buckets() { return m_buckets; }
@property uint count() { return m_count; }
@property ulong countMul() { return m_countMul; }
@property std.uuid.UUID clsId() { return m_clsId; }
@property wchar* srvName() { return m_srvName; }
@property wchar* str() { return m_str; }
@property uint length() { return m_length; }
@property godwit.eehash.BucketTable* bucketTable() { return m_bucketTable; }
@property uint count() { return m_count; }
@property void* heap() { return m_heap; }
@property int growing() { return m_growing; }
@property godwit.eehash.EEHashTable!(godwit.eehash.EEStringData*, godwit.eehash.EEClassFactoryInfoHashTableHelper, true)* stringToEntryHashTable() { return m_stringToEntryHashTable; }
@property godwit.memorypool.MemoryPool* memoryPool() { return m_memoryPool; }
@property ubyte* initialReservedMemForLoaderHeaps() { return m_initialReservedMemForLoaderHeaps; }
@property ubyte[128] lowFreqHeapInstance() { return m_lowFreqHeapInstance; }
@property ubyte[128] highFreqHeapInstance() { return m_highFreqHeapInstance; }
@property ubyte[128] stubHeapInstance() { return m_stubHeapInstance; }
@property ubyte[32] precodeHeapInstance() { return m_precodeHeapInstance; }
@property ubyte[128] fixupPrecodeHeapHeapInstance() { return m_fixupPrecodeHeapHeapInstance; }
@property ubyte[128] newStubPrecodeHeapInstance() { return m_newStubPrecodeHeapInstance; }
@property godwit.loaderheap.LoaderHeap* lowFreqHeap() { return m_lowFreqHeap; }
@property godwit.loaderheap.LoaderHeap* highFreqHeap() { return m_highFreqHeap; }
@property godwit.loaderheap.LoaderHeap* stubHeap() { return m_stubHeap; }
@property godwit.codeman.CodeFragmentHeap* precodeHeap() { return m_precodeHeap; }
@property godwit.loaderheap.LoaderHeap* executableHeap() { return m_executableHeap; }
@property godwit.loaderheap.LoaderHeap* fixupPrecodeHeap() { return m_fixupPrecodeHeap; }
@property godwit.loaderheap.LoaderHeap* newStubPrecodeHeap() { return m_newStubPrecodeHeap; }
@property uint* allocatorObjectHandle() { return m_allocatorObjectHandle; }
@property godwit.fptrstubs.FuncPtrStubs* funcPtrStubs() { return m_funcPtrStubs; }
@property godwit.stringliteralmap.StringLiteralMap* stringLiteralMap() { return m_stringLiteralMap; }
@property godwit.crst.CrstExplicitInit crstLoaderAllocator() { return m_crstLoaderAllocator; }
@property bool gcPressure() { return m_gcPressure; }
@property bool unloaded() { return m_unloaded; }
@property bool terminated() { return m_terminated; }
@property bool marked() { return m_marked; }
@property int gcCount() { return m_gcCount; }
@property bool isCollectible() { return m_isCollectible; }
@property godwit.threads.DeadlockAwareLock deadlock() { return m_deadlock; }
@property godwit.listlock.ListLockBase!(uint)* list() { return m_list; }
@property uint data() { return m_data; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.listlock.ListLockEntryBase!(uint)* next() { return m_next; }
@property uint refCount() { return m_refCount; }
@property godwit.collections.state.HResult hresultCode() { return m_hresultCode; }
@property long initException() { return m_initException; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.crst.CrstStatic crst() { return m_crst; }
@property bool isfInit() { return m_isfInit; }
@property bool hostBreakable() { return m_hostBreakable; }
@property godwit.listlock.ListLockEntryBase!(uint)* head() { return m_head; }
@property godwit.threads.DeadlockAwareLock deadlock() { return m_deadlock; }
@property godwit.listlock.ListLockBase!(godwit.codeversioning.NativeCodeVersion)* list() { return m_list; }
@property godwit.codeversioning.NativeCodeVersion data() { return m_data; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.listlock.ListLockEntryBase!(godwit.codeversioning.NativeCodeVersion)* next() { return m_next; }
@property uint refCount() { return m_refCount; }
@property godwit.collections.state.HResult hresultCode() { return m_hresultCode; }
@property long initException() { return m_initException; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.crst.CrstStatic crst() { return m_crst; }
@property bool isfInit() { return m_isfInit; }
@property bool hostBreakable() { return m_hostBreakable; }
@property godwit.listlock.ListLockEntryBase!(godwit.codeversioning.NativeCodeVersion)* head() { return m_head; }
@property godwit.hash.HashMap idMap() { return m_idMap; }
@property godwit.hash.HashMap mtMap() { return m_mtMap; }
@property godwit.crst.Crst lock() { return m_lock; }
@property godwit.contractimpl.TypeIDProvider idProvider() { return m_idProvider; }
@property uint entryCount() { return m_entryCount; }
@property godwit.sbuffer.SString* friendlyName() { return m_friendlyName; }
@property byte* buffer() { return m_buffer; }
@property ulong size() { return m_size; }
@property ulong totalAlloc() { return m_totalAlloc; }
@property ulong[64] data() { return m_data; }
@property ulong curSize() { return m_curSize; }
@property godwit.appdomain.AppDomain* appDomain() { return m_appDomain; }
@property godwit.qtempls.CQuickArrayList!(uint*) depHndList() { return m_depHndList; }
@property uint depHndListFreeIndex() { return m_depHndListFreeIndex; }
@property uint shrinkHint() { return m_shrinkHint; }
@property godwit.appdomain.PinnedHeapHandleBucket* head() { return m_head; }
@property godwit.appdomain.BaseDomain* domain() { return m_domain; }
@property uint nextBucketSize() { return m_nextBucketSize; }
@property godwit.appdomain.PinnedHeapHandleBucket* freeSearchHint() { return m_freeSearchHint; }
@property uint numEmbeddedFree() { return m_numEmbeddedFree; }
@property godwit.crst.CrstExplicitInit crst() { return m_crst; }
@property godwit.listlock.ListLockBase!(uint)* fileLoadLock() { return m_fileLoadLock; }
@property godwit.crst.CrstExplicitInit domainCrst() { return m_domainCrst; }
@property godwit.crst.CrstExplicitInit domainCacheCrst() { return m_domainCacheCrst; }
@property godwit.crst.CrstExplicitInit domainLocalBlockCrst() { return m_domainLocalBlockCrst; }
@property godwit.crst.CrstExplicitInit crstLoaderAllocatorReferences() { return m_crstLoaderAllocatorReferences; }
@property godwit.crst.CrstExplicitInit crstStaticBoxInitLock() { return m_crstStaticBoxInitLock; }
@property godwit.crst.CrstExplicitInit crstAssemblyList() { return m_crstAssemblyList; }
@property godwit.listlock.ListLockBase!(uint)* classInitLock() { return m_classInitLock; }
@property godwit.listlock.ListLockBase!(godwit.codeversioning.NativeCodeVersion) jitLock() { return m_jitLock; }
source\collections\state.d-mixin-166(166,27): Deprecation: module godwit.codeversioning is not accessible here, perhaps add 'static import godwit.codeversioning;'
source\collections\state.d-mixin-167(167,27): Deprecation: module godwit.codeversioning is not accessible here, perhaps add 'static import godwit.codeversioning;'
source\collections\state.d-mixin-167(167,106): Deprecation: module godwit.codeversioning is not accessible here, perhaps add 'static import godwit.codeversioning;'
@property godwit.listlock.ListLockBase!(uint)* ilStubGenLock() { return m_ilStubGenLock; }
@property godwit.listlock.ListLockBase!(uint)* nativeTypeLoadLock() { return m_nativeTypeLoadLock; }
@property godwit.defaultassemblybinder.DefaultAssemblyBinder* defaultBinder() { return m_defaultBinder; }
@property godwit.gcinterface.IGCHandleStore handleStore() { return m_handleStore; }
@property godwit.appdomain.PinnedHeapHandleTable pinnedHeapHandleTable() { return m_pinnedHeapHandleTable; }
@property godwit.mngstdinterfaces.MngStdInterfacesInfo* mngStdInterfacesInfo() { return m_mngStdInterfacesInfo; }
@property uint sizedRefHandles() { return m_sizedRefHandles; }
@property godwit.contractimpl.TypeIDMap typeIDMap() { return m_typeIDMap; }
@property godwit.contractimpl.TypeIDMap nonGCThreadStaticBlockTypeIDMap() { return m_nonGCThreadStaticBlockTypeIDMap; }
@property godwit.contractimpl.TypeIDMap gcThreadStaticBlockTypeIDMap() { return m_gcThreadStaticBlockTypeIDMap; }
@property godwit.eehash.BucketTable* bucketTable() { return m_bucketTable; }
@property uint count() { return m_count; }
@property void* heap() { return m_heap; }
@property int growing() { return m_growing; }
@property char** table() { return m_table; }
@property godwit.nativeimage.NativeImage* size() { return m_size; }
@property godwit.nativeimage.NativeImage* count() { return m_count; }
@property godwit.nativeimage.NativeImage* occupied() { return m_occupied; }
@property godwit.nativeimage.NativeImage* max() { return m_max; }
@property godwit.crst.CrstExplicitInit reflectionCrst() { return m_reflectionCrst; }
@property godwit.crst.CrstExplicitInit refClassFactCrst() { return m_refClassFactCrst; }
@property godwit.eehash.EEHashTable!(godwit.eehash.ClassFactoryInfo*, godwit.eehash.EEClassFactoryInfoHashTableHelper, true) refClassFactHash() { return m_refClassFactHash; }
@property godwit.comreflectioncache.ReflectionCache!(godwit.comreflectioncache.DispIDCacheElement, int, 128)* refDispIDCache() { return m_refDispIDCache; }
@property uint* hndMissing() { return m_hndMissing; }
@property godwit.sbuffer.SString friendlyName() { return m_friendlyName; }
@property godwit.assembly.Assembly* rootAssembly() { return m_rootAssembly; }
@property godwit.appdomain.AppDomain.ContextFlags contextFlags() { return m_contextFlags; }
@property int refCount() { return m_refCount; }
@property godwit.crst.CrstExplicitInit nativeImageLoadCrst() { return m_nativeImageLoadCrst; }
@property godwit.shash.SHash!(char*, godwit.nativeimage.NativeImage*) nativeImageMap() { return m_nativeImageMap; }
@property godwit.rcwrefcache.RCWRefCache* rcwCache() { return m_rcwCache; }
@property godwit.rcwrefcache.RCWRefCache* rcwRefCache() { return m_rcwRefCache; }
@property godwit.appdomain.AppDomain.Stage stage() { return m_stage; }
@property godwit.appdomain.PinnedHeapHandleBucket* next() { return m_next; }
@property int arraySize() { return m_arraySize; }
@property int currentPos() { return m_currentPos; }
@property int currentEmbeddedFreePos() { return m_currentEmbeddedFreePos; }
@property uint* hndHandleArray() { return m_hndHandleArray; }
@property godwit.objects.BaseObject** arrayData() { return m_arrayData; }
@property uint exceptionCode() { return m_exceptionCode; }
@property uint exceptionFlags() { return m_exceptionFlags; }
@property godwit.pal.ExceptionRecord* exceptionRecord() { return m_exceptionRecord; }
@property void* exceptionAddress() { return m_exceptionAddress; }
@property uint numParams() { return m_numParams; }
@property uint*[15] exceptionInfo() { return m_exceptionInfo; }
@property godwit.pal.ExceptionRecord* exceptionRecord() { return m_exceptionRecord; }
@property godwit.pal.Context* context() { return m_context; }
@property uint control() { return m_control; }
@property uint status() { return m_status; }
@property uint tag() { return m_tag; }
@property uint errorOffset() { return m_errorOffset; }
@property uint errorSelector() { return m_errorSelector; }
@property uint dataOffset() { return m_dataOffset; }
@property uint dataSelector() { return m_dataSelector; }
@property ubyte[80] registerArea() { return m_registerArea; }
@property uint cr0NPXState() { return m_cr0NPXState; }
@property uint contextFlags() { return m_contextFlags; }
@property uint dr0PAL() { return m_dr0PAL; }
@property uint dr1PAL() { return m_dr1PAL; }
@property uint dr2PAL() { return m_dr2PAL; }
@property uint dr3PAL() { return m_dr3PAL; }
@property uint dr4PAL() { return m_dr4PAL; }
@property uint dr5PAL() { return m_dr5PAL; }
@property uint dr6PAL() { return m_dr6PAL; }
@property uint dr7PAL() { return m_dr7PAL; }
@property godwit.pal.FloatingSaveArea floatSave() { return m_floatSave; }
@property uint segGsPAL() { return m_segGsPAL; }
@property uint segFsPAL() { return m_segFsPAL; }
@property uint segEsPAL() { return m_segEsPAL; }
@property uint segDsPAL() { return m_segDsPAL; }
@property uint edi() { return m_edi; }
@property uint esi() { return m_esi; }
@property uint ebx() { return m_ebx; }
@property uint edx() { return m_edx; }
@property uint ecx() { return m_ecx; }
@property uint eax() { return m_eax; }
@property uint ebp() { return m_ebp; }
@property uint eip() { return m_eip; }
@property uint segCs() { return m_segCs; }
@property uint eflags() { return m_eflags; }
@property uint esp() { return m_esp; }
@property uint segSs() { return m_segSs; }
@property ubyte[512] extendedRegisters() { return m_extendedRegisters; }
@property godwit.ex.EXException* innerException() { return m_innerException; }
@property godwit.clrex.StackTraceElement* pStackTrace() { return m_pStackTrace; }
@property uint stackTrace() { return m_stackTrace; }
@property uint frameCount() { return m_frameCount; }
@property uint dynamicMethodItems() { return m_dynamicMethodItems; }
@property uint currentDynamicIndex() { return m_currentDynamicIndex; }
@property uint* ip() { return m_ip; }
@property uint* sp() { return m_sp; }
@property godwit.method.MethodDesc* fn() { return m_fn; }
@property godwit.clrex.StackTraceElement.StackTraceElementFlags flags() { return m_flags; }
@property uint* throwableHandle() { return m_throwableHandle; }
@property uint* hndThrowable() { return m_hndThrowable; }
@property ushort** searchBoundary() { return m_searchBoundary; }
@property uint exceptionCode() { return m_exceptionCode; }
@property void* bottomMostHandler() { return m_bottomMostHandler; }
@property void* topMostHandlerDuringSO() { return m_topMostHandlerDuringSO; }
@property void* esp() { return m_esp; }
@property godwit.clrex.StackTraceInfo stackTraceInfo() { return m_stackTraceInfo; }
@property godwit.exinfo.ExInfo* prevNestedInfo() { return m_prevNestedInfo; }
@property ulong* shadowSP() { return m_shadowSP; }
@property godwit.pal.ExceptionRecord* exceptionRecord() { return m_exceptionRecord; }
@property godwit.pal.ExceptionPointers* exceptionPointers() { return m_exceptionPointers; }
@property int* context() { return m_context; }
@property void* stackAddress() { return m_stackAddress; }
@property bool deliveredFirstChanceNotification() { return m_deliveredFirstChanceNotification; }
@property godwit.assembly.Assembly* assembly() { return m_assembly; }
@property godwit.appdomain.AppDomain* domain() { return m_domain; }
@property godwit.peassembly.PEAssembly* peAssembly() { return m_peAssembly; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property bool isfCollectible() { return m_isfCollectible; }
@property godwit.domainassembly.DomainAssembly* nextInALC() { return m_nextInALC; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.domainassembly.DomainAssembly.FileLoadLevel fileLoadLevel() { return m_fileLoadLevel; }
@property bool isfLoading() { return m_isfLoading; }
@property long exposedModuleObject() { return m_exposedModuleObject; }
@property long exposedAssemblyObject() { return m_exposedAssemblyObject; }
@property godwit.exinfo.ExInfo* error() { return m_error; }
@property bool disableActivationCheck() { return m_disableActivationCheck; }
@property bool hostAssemblyPublished() { return m_hostAssemblyPublished; }
@property int refCount() { return m_refCount; }
@property godwit.peimage.PEImage* peImage() { return m_peImage; }
@property godwit.assemblyname.AssemblyName* assemblyName() { return m_assemblyName; }
@property godwit.assemblybinder.AssemblyBinder* binder() { return m_binder; }
@property bool inTPA() { return m_inTPA; }
@property godwit.domainassembly.DomainAssembly* domainAssembly() { return m_domainAssembly; }
@property godwit.bspace.BinderSpace** table() { return m_table; }
source\collections\state.d-mixin-166(166,39): Deprecation: module godwit.bspace is not accessible here, perhaps add 'static import godwit.bspace;'
source\collections\state.d-mixin-167(167,39): Deprecation: module godwit.bspace is not accessible here, perhaps add 'static import godwit.bspace;'
source\collections\state.d-mixin-167(167,39): Deprecation: module godwit.bspace is not accessible here, perhaps add 'static import godwit.bspace;'
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property godwit.applicationcontext.FailureCacheEntry** table() { return m_table; }
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property godwit.arraylist.ArrayListBlock* next() { return m_next; }
@property uint blockSize() { return m_blockSize; }
@property void* array() { return m_array; }
@property uint blockSize() { return m_blockSize; }
@property void*[5] array() { return m_array; }
@property uint count() { return m_count; }
@property godwit.arraylist.FirstArrayListBlock firstBlock() { return m_firstBlock; }
@property godwit.arraylist.ArrayList elements() { return m_elements; }
@property godwit.applicationcontext.SimpleNameToFileNameMapEntry* table() { return m_table; }
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property int appVersion() { return m_appVersion; }
@property godwit.sbuffer.SString applicationName() { return m_applicationName; }
@property godwit.shash.SHash!(godwit.bspace.BinderSpace*, uint)* executionContext() { return m_executionContext; }
@property godwit.shash.SHash!(godwit.applicationcontext.FailureCacheEntry*, uint)* failureCache() { return m_failureCache; }
@property void* contextCS() { return m_contextCS; }
@property godwit.stringarraylist.StringArrayList platformResourceRoots() { return m_platformResourceRoots; }
@property godwit.stringarraylist.StringArrayList appPaths() { return m_appPaths; }
@property godwit.shash.SHash!(godwit.applicationcontext.SimpleNameToFileNameMapEntry, uint) trustedPlatformAssemblyMap() { return m_trustedPlatformAssemblyMap; }
@property godwit.shash.SHash!(godwit.assemblybinder.SimpleNameToMVIDAndAssembly, uint) assemblySimpleNameMvidCheckHash() { return m_assemblySimpleNameMvidCheckHash; }
@property godwit.applicationcontext.ApplicationContext appContext() { return m_appContext; }
@property int* ptrManagedAssemblyLoadContext() { return m_ptrManagedAssemblyLoadContext; }
@property godwit.sbuffer.SArray!(godwit.assembly.Assembly)* loadedAssemblies() { return m_loadedAssemblies; }
@property char* simpleName() { return m_simpleName; }
@property std.uuid.UUID mvid() { return m_mvid; }
@property char* assemblyRequirementName() { return m_assemblyRequirementName; }
@property bool compositeComponent() { return m_compositeComponent; }
@property godwit.peimage.PEImage* peImage() { return m_peImage; }
@property bool mdImportIsRWDBGUseOnly() { return m_mdImportIsRWDBGUseOnly; }
@property ubyte* mdImport() { return m_mdImport; }
@property ubyte* mdImportUseAccessor() { return m_mdImportUseAccessor; }
@property ubyte* importer() { return m_importer; }
@property ubyte* emitter() { return m_emitter; }
@property uint refCount() { return m_refCount; }
@property bool isSystem() { return m_isSystem; }
@property godwit.bspace.BinderSpace* hostAssembly() { return m_hostAssembly; }
@property godwit.assemblybinder.AssemblyBinder* fallbackBinder() { return m_fallbackBinder; }
@property ulong sizeOfBlob() { return m_sizeOfBlob; }
@property ubyte[] blobData() { return m_blobData; }
@property godwit.ilstubcache.ILStubCacheEntry* table() { return m_table; }
source\collections\state.d-mixin-166(166,48): Deprecation: module godwit.ilstubcache is not accessible here, perhaps add 'static import godwit.ilstubcache;'
source\collections\state.d-mixin-167(167,48): Deprecation: module godwit.ilstubcache is not accessible here, perhaps add 'static import godwit.ilstubcache;'
source\collections\state.d-mixin-167(167,48): Deprecation: module godwit.ilstubcache is not accessible here, perhaps add 'static import godwit.ilstubcache;'
@property uint size() { return m_size; }
@property uint count() { return m_count; }
@property uint occupied() { return m_occupied; }
@property uint max() { return m_max; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.loaderheap.LoaderHeap* heap() { return m_heap; }
@property godwit.methodtable.MethodTable* stubMethodTable() { return m_stubMethodTable; }
@property godwit.shash.SHash!(godwit.ilstubcache.ILStubCacheEntry, uint) hashMap() { return m_hashMap; }
@property godwit.method.MethodDesc* methodDesc() { return m_methodDesc; }
@property godwit.ilstubcache.ILStubHashBlob* blob() { return m_blob; }
@property void* data() { return m_data; }
@property godwit.classhash.EEClassHashEntry* encloser() { return m_encloser; }
@property godwit.classhash.EEClassHashEntry value() { return m_value; }
source\collections\state.d-mixin-166(166,45): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,45): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,45): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
@property godwit.dacenumerablehash.VolatileEntry!(godwit.classhash.EEClassHashEntry)* nextEntry() { return m_nextEntry; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,122): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
@property uint hashValue() { return m_hashValue; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.loaderheap.LoaderHeap* heap() { return m_heap; }
@property godwit.dacenumerablehash.VolatileEntry!(godwit.classhash.EEClassHashEntry)* buckets() { return m_buckets; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
source\collections\state.d-mixin-167(167,120): Deprecation: module godwit.classhash is not accessible here, perhaps add 'static import godwit.classhash;'
@property uint entries() { return m_entries; }
@property bool caseInsensitive() { return m_caseInsensitive; }
@property void* data() { return m_data; }
@property godwit.typehash.EETypeHashEntry value() { return m_value; }
source\collections\state.d-mixin-166(166,43): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,43): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,43): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
@property godwit.dacenumerablehash.VolatileEntry!(godwit.typehash.EETypeHashEntry)* nextEntry() { return m_nextEntry; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,120): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
@property uint hashValue() { return m_hashValue; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.loaderheap.LoaderHeap* heap() { return m_heap; }
@property godwit.dacenumerablehash.VolatileEntry!(godwit.typehash.EETypeHashEntry)* buckets() { return m_buckets; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
source\collections\state.d-mixin-167(167,118): Deprecation: module godwit.typehash is not accessible here, perhaps add 'static import godwit.typehash;'
@property uint entries() { return m_entries; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.instmethhash.InstMethodHashEntry value() { return m_value; }
source\collections\state.d-mixin-166(166,51): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,51): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,51): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
@property godwit.dacenumerablehash.VolatileEntry!(godwit.instmethhash.InstMethodHashEntry)* nextEntry() { return m_nextEntry; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,128): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
@property uint hashValue() { return m_hashValue; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.loaderheap.LoaderHeap* heap() { return m_heap; }
@property godwit.dacenumerablehash.VolatileEntry!(godwit.instmethhash.InstMethodHashEntry)* buckets() { return m_buckets; }
source\collections\state.d-mixin-166(166,36): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,36): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
source\collections\state.d-mixin-167(167,126): Deprecation: module godwit.instmethhash is not accessible here, perhaps add 'static import godwit.instmethhash;'
@property uint entries() { return m_entries; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.ceeload.LookupMap!(uint)* next() { return m_next; }
@property uint** table() { return m_table; }
@property uint count() { return m_count; }
@property uint* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.ceeload.Module)* next() { return m_next; }
@property godwit.ceeload.Module** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.ceeload.Module* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(void)* next() { return m_next; }
@property void** table() { return m_table; }
@property uint count() { return m_count; }
@property void* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(uint) typeRefToMethodTableMap() { return m_typeRefToMethodTableMap; }
@property godwit.ceeload.LookupMap!(godwit.ceeload.Module) manifestModuleRefsMap() { return m_manifestModuleRefsMap; }
@property godwit.ceeload.LookupMap!(void) memberRefMap() { return m_memberRefMap; }
@property godwit.crst.CrstExplicitInit lookupTableCrst() { return m_lookupTableCrst; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property godwit.ceeload.VASigCookieBlock* next() { return m_next; }
@property uint numCookies() { return m_numCookies; }
@property godwit.ceeload.VASigCookie[] cookies() { return m_cookies; }
@property uint sizeOfArgs() { return m_sizeOfArgs; }
@property ubyte* ndirectILStub() { return m_ndirectILStub; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.siginfo.Signature signature() { return m_signature; }
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable)* next() { return m_next; }
@property godwit.methodtable.MethodTable** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.methodtable.MethodTable* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.method.MethodDesc)* next() { return m_next; }
@property godwit.method.MethodDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.method.MethodDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.field.FieldDesc)* next() { return m_next; }
@property godwit.field.FieldDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.field.FieldDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(godwit.typedesc.TypeVarTypeDesc)* next() { return m_next; }
@property godwit.typedesc.TypeVarTypeDesc** table() { return m_table; }
@property uint count() { return m_count; }
@property godwit.typedesc.TypeVarTypeDesc* supportedFlags() { return m_supportedFlags; }
@property godwit.ceeload.LookupMap!(ulong)* next() { return m_next; }
@property ulong** table() { return m_table; }
@property uint count() { return m_count; }
@property ulong* supportedFlags() { return m_supportedFlags; }
@property char* simpleName() { return m_simpleName; }
@property godwit.peassembly.PEAssembly* peAssembly() { return m_peAssembly; }
@property godwit.ceeload.Module.TransientFlags transientFlags() { return m_transientFlags; }
@property godwit.ceeload.Module.PersistentFlags persistentFlags() { return m_persistentFlags; }
@property godwit.ceeload.VASigCookieBlock* vaSigCookieBlock() { return m_vaSigCookieBlock; }
@property godwit.assembly.Assembly* assembly() { return m_assembly; }
@property godwit.crst.CrstExplicitInit crst() { return m_crst; }
@property godwit.crst.CrstExplicitInit fixupCrst() { return m_fixupCrst; }
@property void* symUnmanagedReader() { return m_symUnmanagedReader; }
@property godwit.crst.CrstExplicitInit symUnmanagedReaderCrst() { return m_symUnmanagedReaderCrst; }
@property void* streamSym() { return m_streamSym; }
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable) typeDefToMethodTableMap() { return m_typeDefToMethodTableMap; }   
@property godwit.ceeload.LookupMap!(godwit.method.MethodDesc) methodDefToDescMap() { return m_methodDefToDescMap; }
@property godwit.ceeload.LookupMap!(godwit.field.FieldDesc) fieldDefToDescMap() { return m_fieldDefToDescMap; }
@property godwit.ceeload.LookupMap!(godwit.typedesc.TypeVarTypeDesc) genericParamToDescMap() { return m_genericParamToDescMap; }
@property godwit.ceeload.LookupMap!(godwit.methodtable.MethodTable) genericTypeDefToCanonMethodTableMap() { return m_genericTypeDefToCanonMethodTableMap; }
@property godwit.ceeload.LookupMap!(ulong) methodDefToPropertyInfoMap() { return m_methodDefToPropertyInfoMap; }
@property godwit.ilstubcache.ILStubCache* ilStubCache() { return m_ilStubCache; }
@property uint defaultDllImportSearchPathsAttributeValue() { return m_defaultDllImportSearchPathsAttributeValue; }
@property godwit.classhash.EEClassHashTable* availableClasses() { return m_availableClasses; }
@property godwit.typehash.EETypeHashTable* availableParamTypes() { return m_availableParamTypes; }
@property godwit.crst.CrstExplicitInit instMethodHashTableCrst() { return m_instMethodHashTableCrst; }
@property godwit.instmethhash.InstMethodHashTable* instMethodHashTable() { return m_instMethodHashTable; }
@property uint debuggerJMCProbeCount() { return m_debuggerJMCProbeCount; }
@property godwit.crst.Crst crst() { return m_crst; }
@property godwit.typehandle.TypeHandle typeHandle() { return m_typeHandle; }
@property godwit.typekey.TypeKey typeKey() { return m_typeKey; }
@property int waitCount() { return m_waitCount; }
@property godwit.collections.state.HResult hresult() { return m_hresult; }
@property godwit.ex.EXException* exception() { return m_exception; }
@property bool lockAcquired() { return m_lockAcquired; }
@property godwit.pendingload.TableEntry* next() { return m_next; }
@property uint hashValue() { return m_hashValue; }
@property godwit.pendingload.PendingTypeLoadEntry* data() { return m_data; }
@property godwit.pendingload.TableEntry** buckets() { return m_buckets; }
@property uint numBuckets() { return m_numBuckets; }
@property godwit.pendingload.PendingTypeLoadTable* unresolvedClassHash() { return m_unresolvedClassHash; }
@property godwit.crst.CrstExplicitInit unresolvedClassLock() { return m_unresolvedClassLock; }
@property godwit.crst.CrstExplicitInit availableClassLock() { return m_availableClassLock; }
@property godwit.crst.CrstExplicitInit availableTypesLock() { return m_availableTypesLock; }
@property int unhashedModules() { return m_unhashedModules; }
@property godwit.assembly.Assembly* assembly() { return m_assembly; }
@property godwit.appdomain.BaseDomain* baseDomain() { return m_baseDomain; }
@property godwit.clsload.ClassLoader* classLoader() { return m_classLoader; }
@property godwit.method.MethodDesc* entryPoint() { return m_entryPoint; }
@property godwit.ceeload.Module* ceemodule() { return m_ceemodule; }
@property godwit.peassembly.PEAssembly* peAssembly() { return m_peAssembly; }
@property godwit.assembly.FriendAssemblyDescriptor* friendAssemblyDescriptor() { return m_friendAssemblyDescriptor; }
@property bool isDynamic() { return m_isDynamic; }
@property bool isCollectible() { return m_isCollectible; }
@property godwit.loaderallocator.LoaderAllocator* allocator() { return m_allocator; }
@property ubyte* itypeLib() { return m_itypeLib; }
@property uint interopAttribStatus() { return m_interopAttribStatus; }
@property godwit.corhdr.DebuggerAssemblyControlFlags debuggerFlags() { return m_debuggerFlags; }
@property bool isTerminated() { return m_isTerminated; }
@property godwit.arraylist.ArrayList fullAccessFriendAssemblies() { return m_fullAccessFriendAssemblies; }
@property godwit.arraylist.ArrayList subjectAssemblies() { return m_subjectAssemblies; }
@property int refCount() { return m_refCount; }
@property wchar* simpleName() { return m_simpleName; }
@property wchar* ilFileName() { return m_ilFileName; }
@property wchar* niFileName() { return m_niFileName; }
@property godwit.sbuffer.SString assemblyNameOrPath() { return m_assemblyNameOrPath; }
@property godwit.collections.state.HResult bindingResult() { return m_bindingResult; }