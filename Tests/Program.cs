using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using Godwit;

#if DEBUG
[DllImport(@"C:\Users\stake\Documents\source\repos\godwit\godwit.dll")]
#else
[DllImport("godwit.dll")]
#endif
static extern unsafe void initialize(nint pMOD);

// MethodTable*
// Type.TypeHandle.Value
// MethodDesc*
// MethodBase.MethodHandle.Value
// FieldDesc*
// FieldInfo.FieldHandle.Value
// Module*
// **(nint**)&Module.MethodHandle
// Assembly*
// *(nint*)&RuntimeAssembly
// PCCOR_SIGNATURE
// Signature.m_sig

unsafe
{
    //var handle = typeof(TestStructure).TypeHandle.Value;
    var h = typeof(TestStructure).Module.ModuleHandle;
    var pMod = **(nint**)Unsafe.AsPointer(ref h);
    initialize(pMod);
    //Module mod = pMod.To<Module>();
    //Console.WriteLine(mod.peAssembly.ToString("X"));
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
    static long a;
}