using System.Runtime.InteropServices;
using Godwit.VM;

namespace Godwit;

/// <summary>
/// This is a simple wrapper that serves as the basis for all Godwit data classes.
/// </summary>
public abstract class ICLR
{
    private nint _ptr;
}

public static class Core
{
    [DllImport(@"C:\Users\stake\Documents\source\repos\godwit\godwit.dll", EntryPoint = "initialize")]
    private static extern unsafe bool _initialize(MethodTable* pMT);

    public static unsafe bool Initialize()
    {
        return _initialize((MethodTable*)typeof(Object).TypeHandle.Value);
    }
}