module godwit.make;

import std.string;
import std.array;
import godwit.mem;
import std.file;
import std.algorithm;
import std.stdio : writeln;
import std.traits;
import std.conv;
import std.meta;

private pure string toPascalCase(string input) 
{
    auto words = input.split(".");
    auto result = appender!string;

    foreach (word; words) {
        if (!word.empty) {
            result.put(toUpper(word[0]).to!string~word[1..$]~".");
        }
    }

    return result.data[0..$-1];
}

/**
    Automatic C# and .h binding generator.

    Remarks:
        Same requirements as `godwit.llv.traits.imports` \
        Depends on Godwit.Importer for C# \
        Depends on types having accessors generated using `mixin accessors`
*/
public template make(alias root, string dest)
{
    // TODO: Generic instantiations
    //       Inherits (actual inherits & subtypes [alias this])
    public void csharp(string[] inherits...) 
    {
        const cs = dest~"\\csharp\\"~fullyQualifiedName!root;
        foreach (mod; imports!root)
        {
            string path = cs~"\\"~fullyQualifiedName!mod~"\\";
            if (path.exists)
                path.rmdirRecurse;
            path.mkdirRecurse;

            string prev;
            foreach (type; __traits(allMembers, mod)[2..$])
            {
                static if ( isType!(__traits(getMember, mod, type)) && !__traits(isTemplate, __traits(getMember, mod, type)) && isAggregateType!(__traits(getMember, mod, type)))
                {
                    string file = path~type~".cs";
                    if (prev != file && prev != null)
                        prev.append("\n}");
                    prev = file;

                    if (inherits.length != 0)
                        file.append("// Auto generated by godwit.make\nnamespace "~(fullyQualifiedName!root).toPascalCase()~";\n\npublic unsafe class "~type~" : "~inherits.joiner(", ").array.to!string~"\n{\n");
                    else 
                        file.append("// Auto generated by godwit.make\nnamespace "~(fullyQualifiedName!root).toPascalCase()~";\n\npublic unsafe class "~type~"\n{\n");

                    foreach (member; __traits(allMembers, __traits(getMember, mod, type)))
                    {
                        alias A = __traits(getMember, __traits(getMember, mod, type), member);
                        static if (isType!A && is(A == enum))
                        {
                            static if (staticIndexOf!(flags, __traits(getAttributes, A)) != -1)
                                file.append("    [Flags]\n    public enum "~__traits(identifier, A)~" : "~fullyQualifiedName!(OriginalType!(typeof(__traits(getMember, A, __traits(allMembers, A)[0]))))~"\n    {\n");
                            else
                                file.append("    public enum "~__traits(identifier, A)~" : "~fullyQualifiedName!(OriginalType!(typeof(__traits(getMember, A, __traits(allMembers, A)[0]))))~"\n    {\n");

                            foreach (memenum; __traits(allMembers, A))
                                file.append("        "~memenum~" = "~(cast(OriginalType!(typeof(__traits(getMember, A, memenum))))__traits(getMember, A, memenum)).to!string~",\n");
                            file.append("    }\n\n");
                            
                        }
                        else static if (isCallable!A && isFunction!A && isExport!A)
                        {
                            string retType = (fullyQualifiedName!(ReturnType!A)).pragmatize().replace("PTR", "*");
                            string mangle = type~"_"~__traits(identifier, A);

                            if (retType.endsWith('*'))
                                file.append("    public "~retType~" "~__traits(identifier, A)~" { get { return ("~retType~")Core.Importer.Call<nint>(\""~mangle~"_get\", _ptr); } set { Core.Importer.Call<nint>(\""~mangle~"_get\", _ptr, (nint)value); } }\n");
                            else
                                file.append("    public "~retType~" "~__traits(identifier, A)~" { get { return Core.Importer.Call<"~retType~">(\""~mangle~"_get\", _ptr); } set { Core.Importer.Call<"~retType~">(\""~mangle~"_get\", _ptr, value); } }\n");
                        }
                    }
                }
            }
            if (prev != null)
                prev.append("\n}");
        }
    }
}