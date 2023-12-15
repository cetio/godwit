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
// THESE DO NOT BELONG HERE!
// Add mask support!
// Generates gets/sets
// Assumes standardizes prefixes! (m_ for backing fields, k for masked enum values)
static foreach (string member; FieldNameTuple!(typeof(this)))
    {
    	mixin("ref " ~ fullyQualifiedName!(typeof(__traits(getMember, this, member))) ~ " " ~ member[2..$] ~ "() { return " ~ member ~ "; }");
        
        // Does not support multiple fields with the same enum type!
        static if (is(typeof(__traits(getMember, this, member)) == enum))
        {
            static foreach (flag; EnumMembers!(typeof(__traits(getMember, this, member))))
            {
                // ex: Eastern
                // Masked (k prefix)
                static if ((flag.to!string).startsWith('k'))
                {
					pragma(msg, "Unimplemented masked flag set/get " ~ flag.to!string);
                }
                else
                {
                    // @property bool isEastern()...
                	mixin("@property bool is" ~ flag.to!string ~ "() { return (" ~ member ~ " & " ~ fullyQualifiedName!(typeof(__traits(getMember, this, member))) ~ "." ~ flag.to!string ~ ") != 0; }");
                	// @property bool isEastern(bool state)...
                	mixin("@property bool is" ~ flag.to!string ~ "(bool state) { return ((" ~ member ~ " = state ? (" ~ member ~ " | " ~ fullyQualifiedName!(typeof(__traits(getMember, this, member))) ~ "." ~ flag.to!string ~ ") : (" ~ member ~ " & ~" ~ fullyQualifiedName!(typeof(__traits(getMember, this, member))) ~ "." ~ flag.to!string ~ ")) & " ~ fullyQualifiedName!(typeof(__traits(getMember, this, member))) ~ "." ~ flag.to!string ~ ") != 0; }");
                }
            }
        }
    }