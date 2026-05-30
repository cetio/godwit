module godwit.core.method;

import godwit.backend.vm.method;
import godwit.backend.vm.methodtable;
import godwit.backend.metadata;
import godwit.core.reflection;
import godwit.impl;

public struct Method
{
package:
final:
    MethodDesc* methodDesc;

public:
    string name()
    {
        IMetaDataImport importer = getImporter(methodDesc.methodDescChunk.methodTable);
        return getMethodDefName(importer, token);
    }

    MethodDef token()
        => methodDesc.token;

    bool isStatic()
        => (methodDesc.flags & MethodDesc.Properties.Static) != 0;

    bool valid()
        => methodDesc != null;

    bool isGenericMethodDefinition()
    {
        if (methodDesc == null)
            return false;
        if (methodDesc.classification != MethodDesc.Classification.Instantiated)
            return false;
        auto inst = cast(InstantiatedMethodDesc*)methodDesc;
        return inst.numGenericArgs > 0;
    }

    void patchVtable(void* functionPointer)
    {
        MethodTable* mt = methodDesc.methodDescChunk.methodTable;
        size_t** indirections = cast(size_t**)(cast(ubyte*)mt + MethodTable.sizeof);
        size_t index = methodDesc.slotNumber >> 3;
        size_t offset = methodDesc.slotNumber & 7;
        size_t* chunk = cast(size_t*)indirections[index];
        size_t* slotAddr = &chunk[offset];

        version (Posix)
        {
            import core.sys.posix.unistd : sysconf;
            import core.sys.posix.sys.mman :
                mprotect,
                PROT_READ,
                PROT_WRITE;
            long pageSize = sysconf(30);
            void* page = cast(void*)((cast(size_t)slotAddr) & ~(cast(size_t)pageSize - 1));
            mprotect(page, cast(size_t)pageSize, PROT_READ | PROT_WRITE);
        }

        *slotAddr = cast(size_t)functionPointer;
    }

    void* entryPoint()
    {
        if ((methodDesc.flags & MethodDesc.Properties.HasNonVtableSlot) != 0)
        {
            size_t base = methodDesc.baseSize;
            static if (COM_INTEROP)
                base += ComPlusCallInfo.sizeof;
            return *cast(void**)(cast(ubyte*)methodDesc + base);
        }
        else
        {
            MethodTable* mt = methodDesc.methodDescChunk.methodTable;
            size_t** indirections = cast(size_t**)(cast(ubyte*)mt + MethodTable.sizeof);
            size_t index = methodDesc.slotNumber >> 3;
            size_t offset = methodDesc.slotNumber & 7;
            size_t* chunk = cast(size_t*)indirections[index];
            return cast(void*)chunk[offset];
        }
    }

    void* invoke(void* target, void*[] args)
    {
        alias Fn0 = extern(C) void* function(void*);
        alias Fn1 = extern(C) void* function(void*, void*);
        alias Fn2 = extern(C) void* function(void*, void*, void*);
        alias Fn3 = extern(C) void* function(void*, void*, void*, void*);
        alias Fn4 = extern(C) void* function(void*, void*, void*, void*, void*);
        alias Fn5 = extern(C) void* function(void*, void*, void*, void*, void*, void*);

        auto fn = entryPoint();
        switch (args.length)
        {
            case 0:
                return (cast(Fn0)fn)(target);
            case 1:
                return (cast(Fn1)fn)(target, args[0]);
            case 2:
                return (cast(Fn2)fn)(target, args[0], args[1]);
            case 3:
                return (cast(Fn3)fn)(target, args[0], args[1], args[2]);
            case 4:
                return (cast(Fn4)fn)(target, args[0], args[1], args[2], args[3]);
            case 5:
                return (cast(Fn5)fn)(target, args[0], args[1], args[2], args[3], args[4]);
            default:
                throw new Exception("invoke with more than 5 args is not supported yet");
        }
    }

    void* invokeStatic(void*[] args)
    {
        alias SFn0 = extern(C) void* function();
        alias SFn1 = extern(C) void* function(void*);
        alias SFn2 = extern(C) void* function(void*, void*);
        alias SFn3 = extern(C) void* function(void*, void*, void*);
        alias SFn4 = extern(C) void* function(void*, void*, void*, void*);
        alias SFn5 = extern(C) void* function(void*, void*, void*, void*, void*);

        auto fn = entryPoint();
        switch (args.length)
        {
            case 0:
                return (cast(SFn0)fn)();
            case 1:
                return (cast(SFn1)fn)(args[0]);
            case 2:
                return (cast(SFn2)fn)(args[0], args[1]);
            case 3:
                return (cast(SFn3)fn)(args[0], args[1], args[2]);
            case 4:
                return (cast(SFn4)fn)(args[0], args[1], args[2], args[3]);
            case 5:
                return (cast(SFn5)fn)(args[0], args[1], args[2], args[3], args[4]);
            default:
                throw new Exception("invokeStatic with more than 5 args is not supported yet");
        }
    }
}