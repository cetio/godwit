using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Text;
using System.Linq;

#if DEBUG
[DllImport("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll")]
#else
        [DllImport("kingfisher.dll")]
#endif
static extern unsafe void Initialize(nint pmt, string filePath);

if (!File.Exists("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll"))
    throw new Exception("Kingfisher.dll not found!");

unsafe
{
    var handle = typeof(TestStructure).Module.ModuleHandle;
    Initialize(*(nint*)Unsafe.AsPointer(ref handle), AppDomain.CurrentDomain.BaseDirectory + "\\tests.dll");
    /*int a = 1;
    float b = 3.1415f;
    TestStructure c = new TestStructure(1, 2, 3, 4, 5, 6);
    int d = 88;
    int e = -1;
    int f = -2;
    ulong ret = InvokeVTEx(typeof(Program).GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static)[2].MethodHandle.GetFunctionPointer(), pargs, pseries);
    Console.WriteLine(Unsafe.As<ulong, int>(ref ret));*/
    Console.ReadLine();
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