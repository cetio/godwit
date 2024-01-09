/// Provides advanced shallow and deep cloning support
module godwit.mem.ddup;

import std.traits;

private struct A
{
    int aa;
}

private class B
{
    A aa;
    C bb;
}

private class C
{
    float cc;
}

public:
static:
/**
    Shallow clones a value.

    Params:
    - `val`: The value to be shallow cloned.

    Returns:
        A shallow clone of the provided value.

    Example usage:
        ```d
        A a;
        A b = a.dup();
        ```
*/
pure @nogc @trusted T dup(T)(T val)
    if (!isArray!T && !isAssociativeArray!T)
{
    // Cloned when passed as a parameter
    return val;
}

/// ditto
pure @trusted T dup(T)(T arr)
    if (isArray!T && !isAssociativeArray!T)
{
    T ret;
    foreach (u; arr)
        ret ~= u.dup();
    return ret;
}

/// ditto
pure @trusted T dup(T)(T arr)
    if (isAssociativeArray!T)
{
    T ret;
    foreach (key, value; arr)
        ret[key.dup()] = value.dup();
    return ret;
}


unittest 
{
    A a;
    A b = a.dup();
    a.aa = 2;
    assert(b.aa == 0);

    A c = a.dup();
    assert(c.aa == 2);
}

/**
    Deep clones a value.

    Params:
    - `val`: The value to be deep cloned.

    Returns:
        A deep clone of the provided value.

    Example usage:
        ```d
        B a; // where B is a class containing indirection
        B b = a.ddup();
        ```
*/
pure @trusted T ddup(T)(const T val)
    if (!isArray!T && !isAssociativeArray!T)
{
    static if (!hasIndirections!T)
        return val;
    else
    {
        T ret = new T();
        static foreach (field; FieldNameTuple!T)
        {
            static if (!hasIndirections!T)
                __traits(getMember, ret, field) = __traits(getMember, val, field);
            else
                __traits(getMember, ret, field) = __traits(getMember, val, field).ddup();
        }
        return ret;
    }
}

/// ditto
pure @trusted T ddup(T)(T arr)
    if (isArray!T && !isAssociativeArray!T)
{
    T ret;
    foreach (u; arr)
        ret ~= u.ddup();
    return ret;
}

/// ditto
pure @trusted T ddup(T)(T arr)
    if (isAssociativeArray!T)
{
    T ret;
    foreach (key, value; arr)
        ret[key.ddup()] = value.ddup();
    return ret;
}

unittest
{
    B d = new B();
    d.bb = new C();
    d.bb.cc = 7f;
    assert(d.bb.cc == 7f);

    B e = d.ddup();
    assert(e.bb.cc == 7f);

    e.bb.cc = 8f;
    assert(e.bb.cc == 8f);
    assert(d.bb.cc == 7f);
}