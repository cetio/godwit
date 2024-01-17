module godwit.corinfo;

//                            ...Type
public enum SystemVClassification : ubyte
{
    Unknown = 0,
    Struct = 1,
    NoClass = 2,
    Memory = 3,
    Integer = 4,
    IntegerReference = 5,
    IntegerByRef = 6,
    SSE = 7,
}