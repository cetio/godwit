/// Provides helpers for resolving metadata names via the IMetaDataImport COM interface.
module godwit.core.reflection;

import godwit.backend.vm.peassembly;
import godwit.backend.vm.ceeload;
import godwit.backend.vm.methodtable;
import godwit.backend.vm.method;
import godwit.backend.vm.field;
import godwit.backend.metadata;
import godwit.hresult;
import std.utf;

alias IMetaDataImport = void*;

private alias GetTypeDefPropsFn = extern(C) int function(
    void* importer,
    uint td,
    wchar* szTypeDef,
    uint cchTypeDef,
    uint* pchTypeDef,
    uint* pdwTypeDefFlags,
    uint* ptkExtends
);

private alias GetMethodPropsFn = extern(C) int function(
    void* importer,
    uint mb,
    uint* pClass,
    wchar* szMethod,
    uint cchMethod,
    uint* pchMethod,
    uint* pdwAttr,
    ubyte** ppvSigBlob,
    uint* pcbSigBlob,
    uint* pulCodeRVA,
    uint* pdwImplFlags
);

private alias GetFieldPropsFn = extern(C) int function(
    void* importer,
    uint mb,
    uint* pClass,
    wchar* szField,
    uint cchField,
    uint* pchField,
    uint* pdwAttr,
    ubyte** ppvSigBlob,
    uint* pcbSigBlob,
    uint* pdwCPlusTypeFlag,
    void** ppValue,
    uint* pcchValue
);

IMetaDataImport getImporter(MethodTable* mt)
{
    if (mt == null || mt.ceemodule == null)
        return null;

    PEAssembly* peAssembly = mt.ceemodule.peAssembly;
    if (peAssembly == null)
        return null;

    return peAssembly.importer;
}

string getTypeDefName(IMetaDataImport importer, TypeDef token)
{
    if (importer == null)
        return null;

    auto vtable = *(cast(size_t**)importer);
    auto fn = cast(GetTypeDefPropsFn)vtable[12];

    wchar[512] buffer = void;
    uint count = 0;
    uint flags = 0;
    uint extends = 0;

    int hr = fn(importer, token, buffer.ptr, buffer.length, &count, &flags, &extends);
    if (hr != 0 || count == 0)
        return null;

    return toUTF8(buffer[0 .. count]);
}

string getMethodDefName(IMetaDataImport importer, MethodDef token)
{
    if (importer == null)
        return null;

    auto vtable = *(cast(size_t**)importer);
    auto fn = cast(GetMethodPropsFn)vtable[30];

    wchar[512] buffer = void;
    uint count = 0;
    uint classToken = 0;
    uint attr = 0;
    ubyte* sig = null;
    uint sigLen = 0;
    uint codeRva = 0;
    uint implFlags = 0;

    int hr = fn(
        importer, token, &classToken, buffer.ptr, buffer.length, &count, &attr, &sig, &sigLen, &codeRva, &implFlags);
    if (hr != 0 || count == 0)
        return null;

    return toUTF8(buffer[0 .. count]);
}

string getFieldDefName(IMetaDataImport importer, FieldDef token)
{
    if (importer == null)
        return null;

    auto vtable = *(cast(size_t**)importer);
    auto fn = cast(GetFieldPropsFn)vtable[57];

    wchar[512] buffer = void;
    uint count = 0;
    uint classToken = 0;
    uint attr = 0;
    ubyte* sig = null;
    uint sigLen = 0;
    uint cplusTypeFlag = 0;
    void* value = null;
    uint valueLen = 0;

    int hr = fn(
        importer, token, &classToken, buffer.ptr, buffer.length, &count, &attr, &sig, &sigLen, &cplusTypeFlag, &value,
        &valueLen);
    if (hr != 0 || count == 0)
        return null;

    return toUTF8(buffer[0 .. count]);
}

import godwit.core.type;

Type findTypeByName(Module* ceemodule, string name)
{
    if (ceemodule == null)
        return Type.init;

    IMetaDataImport importer = ceemodule.peAssembly != null ? ceemodule.peAssembly.importer : null;
    if (importer == null)
        return Type.init;

    LookupMap!MethodTable* map = &ceemodule.typeDefToMethodTableMap;
    while (map != null)
    {
        if (map.table != null)
        {
            for (uint i = 0; i < map.count; i++)
            {
                MethodTable* mt = map.table[i];
                if (mt != null)
                {
                    Type t = cast(Type)mt;
                    if (t.name == name)
                        return t;
                }
            }
        }
        map = map.next;
    }
    return Type.init;
}
