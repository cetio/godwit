module godwit.make;

import std.stdio;
import std.string;
import godwit.mem;

public static void makeCs()
{
    foreach (type; __traits(allMembers, godwit.method)[3..$])
    {
        foreach (member; __traits(allMembers, __traits(getMember, godwit.method, type)))
        {
            //if (member)
        }
    }
}