set PATH=C:\D\ldc2-1.35.0-windows-multilib\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\bin\HostX86\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE;C:\Program Files (x86)\Windows Kits\10\bin;%PATH%
set LIB=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\lib\x64;C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64;C:\Program Files (x86)\Windows Kits\10\lib\10.0.22621.0\um\x64
set VCINSTALLDIR=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\
set VCTOOLSINSTALLDIR=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.38.33130\
set VSINSTALLDIR=C:\Program Files\Microsoft Visual Studio\2022\Community\
set WindowsSdkDir=C:\Program Files (x86)\Windows Kits\10\
set WindowsSdkVersion=10.0.22621.0
set UniversalCRTSdkDir=C:\Program Files (x86)\Windows Kits\10\
set UCRTVersion=10.0.22621.0

echo binder\applicationcontext.d >"x64\Debug LDC\godwit.build.rsp"
echo binder\assemblyidentity.d >>"x64\Debug LDC\godwit.build.rsp"
echo binder\assemblyname.d >>"x64\Debug LDC\godwit.build.rsp"
echo binder\assemblyversion.d >>"x64\Debug LDC\godwit.build.rsp"
echo binder\bspace.d >>"x64\Debug LDC\godwit.build.rsp"
echo gc\gcdesc.d >>"x64\Debug LDC\godwit.build.rsp"
echo gc\gcenv.d >>"x64\Debug LDC\godwit.build.rsp"
echo gc\gcinterface.d >>"x64\Debug LDC\godwit.build.rsp"
echo gc\qtempls.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\arraylist.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\bundle.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\cor.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\corhdr.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\ex.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\loaderheap.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\memorypool.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\pal.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\readytorun.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\sbuffer.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\shash.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc\stringarraylist.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\elf\header.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\elf\program.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\elf\sections.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\pe\optional.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\pe\standard.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\abi.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\cil.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\formats.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\metadata.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\packedfields.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\state.d >>"x64\Debug LDC\godwit.build.rsp"
echo misc\stream.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\appdomain.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\assembly.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\assemblybinder.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\ceeload.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\classhash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\clrex.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\clsload.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\codeman.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\codeversioning.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\comreflectioncache.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\contractimpl.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\crst.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\dacenumerablehash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\defaultassemblybinder.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\domainassembly.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\eeclass.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\eehash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\exinfo.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\field.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\fptrstubs.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\genericdict.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\hash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\ilstubcache.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\inlinetracking.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\instmethhash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\listlock.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\loaderallocator.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\method.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\methodimpl.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\methodtable.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\mngstdinterfaces.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\nativeimage.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\objects.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\peassembly.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\peimage.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\peimagelayout.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\pendingload.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\precode.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\rcwrefcache.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\readytoruninfo.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\siginfo.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\simplerwlock.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\stringliteralmap.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\stub.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\threads.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\typectxt.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\typedesc.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\typehandle.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\typehash.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm\typekey.d >>"x64\Debug LDC\godwit.build.rsp"
echo binder.d >>"x64\Debug LDC\godwit.build.rsp"
echo gc.d >>"x64\Debug LDC\godwit.build.rsp"
echo inc.d >>"x64\Debug LDC\godwit.build.rsp"
echo lure.d >>"x64\Debug LDC\godwit.build.rsp"
echo main.d >>"x64\Debug LDC\godwit.build.rsp"
echo readers.d >>"x64\Debug LDC\godwit.build.rsp"
echo vm.d >>"x64\Debug LDC\godwit.build.rsp"

"C:\Program Files (x86)\VisualD\pipedmd.exe" -deps "x64\Debug LDC\godwit.dep" ldc2 -m64 -g -d-debug -X -Xf="x64\Debug LDC\godwit.json" -of="x64\Debug LDC\godwit.dll" -L/PDB:"x64\Debug LDC\godwit.pdb" -L/SUBSYSTEM:CONSOLE -L/DLL -od="x64\Debug LDC" @"x64\Debug LDC\godwit.build.rsp"
if %errorlevel% neq 0 goto reportError
if not exist "x64\Debug LDC\godwit.dll" (echo "x64\Debug LDC\godwit.dll" not created! && goto reportError)

goto noError

:reportError
set ERR=%ERRORLEVEL%
set DISPERR=%ERR%
if %ERR% LSS -65535 set DISPERR=0x%=EXITCODE%
echo Building x64\Debug LDC\godwit.dll failed (error code %DISPERR%)!
exit /B %ERR%

:noError
