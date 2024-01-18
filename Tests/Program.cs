using System.Drawing;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using Godwit;

#if DEBUG
[DllImport(@"C:\Users\stake\source\repos\godwit\godwit.dll")]
#else
[DllImport("godwit.dll")]
#endif
static extern unsafe bool initialize(nint pMT);

#if DEBUG
[DllImport(@"C:\Users\stake\source\repos\godwit\godwit.dll")]
#else
[DllImport("godwit.dll")]
#endif
static extern unsafe void fields(nint pMT);

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
    //Console.WriteLine(initialize(typeof(TestStructure).TypeHandle.Value));
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

class GodwitType
{
    public nint pMT;
}

struct TestStructure
{
    int a;
}