namespace Godwit.VM;

public class TypeDesc : ICLR
{
    [Flags]
    public enum TypeFlags
    {
        Unrestored = 0x00000400,
        UnrestoredTypeKey = 0x00000800,
        IsNotFullyLoaded = 0x00001000,
        DependenciesLoaded = 0x00002000,
        HasTypeEquivalence = 0x00004000
    }
}

public class ParamTypeDesc : TypeDesc
{

}

public class TypeVarTypeDesc : TypeDesc
{

}

public class FnPtrTypeDesc : TypeDesc
{

}