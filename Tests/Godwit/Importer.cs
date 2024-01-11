namespace Godwit;

using System.Diagnostics;
using System.Linq.Expressions;
using System.Reflection;
using System.Runtime.InteropServices;

public class Importer
{
    private readonly nint _lib;

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool FreeLibrary(nint lib);

    [DllImport("Kernel32.dll", CharSet = CharSet.Ansi)]
    private static extern IntPtr LoadLibrary(string path);

    [DllImport("Kernel32.dll", CharSet = CharSet.Ansi, ExactSpelling = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    private static readonly Func<Type[], Type> CreateDynamicDelegate = (Func<Type[], Type>)Delegate.CreateDelegate(typeof(Func<Type[], Type>),
            typeof(Expression).Assembly.GetType("System.Linq.Expressions.Compiler.DelegateHelpers")!
            .GetMethod("MakeNewCustomDelegate", BindingFlags.NonPublic | BindingFlags.Static)!);

    public Importer()
    {
        _lib = LoadLibrary(@"C:\Users\stake\Documents\source\repos\godwit\godwit.dll");
    }

    ~Importer()
    {
        FreeLibrary(_lib);
    }

    public unsafe T Call<T>(string ep, nint p)
    {
        Type[] args = new Type[2] { typeof(nint), typeof(T) };
        return ((dynamic)Marshal.GetDelegateForFunctionPointer(GetProcAddress(_lib, ep), CreateDynamicDelegate(args)))(p);
    }

    public unsafe T Call<T>(string ep, nint p, T v)
    {
        Type[] args = new Type[3] { typeof(nint), typeof(T), typeof(T) };
        return ((dynamic)Marshal.GetDelegateForFunctionPointer(GetProcAddress(_lib, ep), CreateDynamicDelegate(args)))(p, v);
    }
}