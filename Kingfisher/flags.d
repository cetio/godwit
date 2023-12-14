module flags;

import std.traits;

public:
static:
bool hasFlag(T)(T value, T flag)
{
    return (value & flag) != 0;
}

bool hasFlagMasked(T)(T value, T mask, T flag)
{
    return (value & mask) == flag;
}

void setFlag(T)(ref T value, T flag, bool state)
{
    value = cast(T)(state ? (value | flag) : (value & ~flag));
}

void toggleFlag(T)(ref T value, T flag)
{
    value = cast(T)(value ^ flag);
}

void setFlagMasked(T)(ref T value, T mask, T flag, bool state)
{
    value = cast(T)(state ? (value & mask) | flag : (value & mask) & ~flag);
}

void toggleFlagMasked(T)(ref T value, T mask, T flag)
{
    value = cast(T)((value & mask) ^ flag);
}

T clearMask(T)(T value, T mask)
{
    return cast(T)(value & ~mask);
}

string toString(T)(T value)
{
    foreach (string member; __traits(allMembers, T))
    {
        if (value.hasFlag(__traits(getMember, T, member)))
        {
            string str;
            foreach (m; __traits(allMembers, T))
            {
                if (value.hasFlag(__traits(getMember, T, m)))
                    str ~= m ~ " | ";
            }
            return str[0 .. $ - 3];
        }
    }
    return __traits(allMembers, T)[0];
}