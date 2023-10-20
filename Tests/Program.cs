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
static extern unsafe void DumpRegisters();

#if DEBUG
[DllImport("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll")]
#else
        [DllImport("kingfisher.dll")]
#endif
static extern unsafe void DumpStack();

#if DEBUG
[DllImport("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll")]
#else
        [DllImport("kingfisher.dll")]
#endif
static extern unsafe int GetBaseSize(nint pmd);

#if DEBUG
[DllImport("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll")]
#else
        [DllImport("kingfisher.dll")]
#endif
static extern unsafe int GetOptionalSize(nint pmd);

if (!File.Exists("C:\\Users\\cet\\source\\repos\\kingfisher\\kingfisher\\x64\\Debug\\kingfisher.dll"))
    throw new Exception("Kingfisher.dll not found!");

unsafe
{
    ConvCPP2D("C:\\Users\\cet\\Downloads\\typehandle.h", null);
    int a = 3;
    nint pmd = typeof(Program).GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static)[3].MethodHandle.Value;
    Console.WriteLine(GetBaseSize(pmd) + GetOptionalSize(pmd));
    Console.WriteLine(typeof(Program).GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static)[4].MethodHandle.Value - pmd);
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

static void ConvCPP2D(string inputPath, string outputPath)
{
    try
    {
        string cppCode = File.ReadAllText(inputPath);
        StringBuilder dCode = new StringBuilder();

        // Use regular expressions to find class and struct declarations
        var typeMatches = Regex.Matches(cppCode, @"(class|struct)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\{(.+?)\};", RegexOptions.Singleline);

        foreach (Match typeMatch in typeMatches)
        {
            dCode.AppendLine($"// AUTO GENERATED");
            dCode.AppendLine($"public struct {typeMatch.Groups[2].Value}\n{{\npublic:");
            
            // Use regular expressions to find fields inside the class/struct
            var fieldMatches = Regex.Matches(typeMatch.Groups[3].Value, @"^\s{4}(\w+|\w+[*])\s+(\w+);", RegexOptions.Multiline);

            foreach (Match fieldMatch in fieldMatches)
            {
                dCode.AppendLine($"    {fieldMatch.Groups[1].Value} {fieldMatch.Groups[2].Value};");
            }

            dCode.AppendLine("}\n");
        }

        //File.WriteAllText(outputPath, dCode.ToString());
        Console.WriteLine("Conversion completed successfully.");
        Console.WriteLine(dCode.ToString());
    }
    catch (Exception ex)
    {
        Console.WriteLine($"An error occurred: {ex.Message}");
    }
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