namespace Godwit;

using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;

/// <summary>
/// This is a simple wrapper that serves as the basis for all Godwit data classes.
/// </summary>
public class ICLR
{
    internal nint _ptr;
}

public static class ICLRConv
{
    public static T To<T>(this nint p) where T : ICLR
    {
        ICLR c = new ICLR();
        c._ptr = p;
        return Unsafe.As<ICLR, T>(ref c);
    }
}

public static class Core
{
    public static Importer Importer = new Importer();

    [DllImport(@"C:\Users\stake\Documents\source\repos\godwit\godwit.dll", EntryPoint = "initialize")]
    private static extern unsafe bool _initialize(nint pMT);

    public static unsafe bool Initialize()
    {
        return _initialize((nint)typeof(object).TypeHandle.Value);
    }
}