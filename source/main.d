module godwit.main;

//import core.sys.windows.windows;
//import core.sys.windows.dll;
import godwit.appdomain;
import godwit.ceeload;
import godwit.methodtable;
import godwit.assembly;
import godwit.loaderallocator;
import std.stdio;
import godwit.eeclass;

//mixin SimpleDllMain;

import std.stdio;
import std.file;
import std.array;
import std.conv;


int main()
{
    Initialize();
    readln();
    return 1;
}

extern (C) export void initialize()
{
}