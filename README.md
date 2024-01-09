# Godwit

[![License](https://img.shields.io/badge/License-MPL--2-blue)](#license)
[![Build - Intangible](https://img.shields.io/badge/Build-Intangible-informational)](https://)

D-CoreCLR interop library, intended to allow D and other bound languages to interact with C# programs without any explicit back and forth between the languages. This is achieved by directly translating CoreCLR structures and code into D.

As of present, the interacting language must be initialized by C#, due to the constraint of not knowing where the `AppDomain` is located in memory.

## Support

Godwit is intended to have support for all of the things that `System.Reflection` in C# supports, including PE/metadata reading, assembly, disassembly, and execution of IL code.

However, until Godwit is near completion, implementation flags will not be fully supported, meaning that Godwit is incredibly volatile unless you can absolutely guarantee there is no mismatch.

### Equivalence

`PropertyInfo` are effectively `MethodBase`, `EventInfo` appear to be effectively `FieldInfo`, `ParameterInfo` & return info are part of signatures (`PCCOR_SIGNATURE`) 

| C# | Godwit |
-----|--------|
| `AppDomain` | `godwit.appdomain.AppDomain` |
| `Assembly` | `godwit.assembly.Assembly` |
| `AssemblyName` | `godwit.assemblyidentity.AssemblyIdentity` |
| `Module` | `godwit.ceeload.Module` |
| `Type` | `godwit.methodtable.MethodTable` |
| `TypeInfo` | `godwit.methodtable.MethodTable` |
| `TypeHandle` | `godwit.typehandle.TypeHandle` |
| `MemberInfo` | TBD |
| `ParameterInfo` | TBD |
| `EventInfo` | TBD |
| `MethodBase` | `godwit.method.*MethodDesc` |
| `MethodBody` | `godwit.method.*MethodDesc` |
| `MethodInfo` | `godwit.method.*MethodDesc` |
| `ConstructorInfo` | `godwit.method.*MethodDesc` |
| `PropertyInfo` | `godwit.method.*MethodDesc` |
| `RuntimeMethodHandle` | `godwit.method.*MethodDesc` |
| `Delegate` | `godwit.stub.Stub` TBD |
| `Action<T..>` | `godwit.stub.Stub` TBD |
| `Func<T..>` | `godwit.stub.Stub` TBD |
| `FieldInfo` | `godwit.field.FieldDesc` |
| `RuntimeFieldHandle` | `godwit.field.FieldDesc` |
| `Object` | `godwit.objects.BaseObject` |
| `Object*` | `godwit.objects.ObjectHandle` TBD |
| `ObjectHandle->Missing` | `godwit.appdomain.AppDomain.hndMissing` |
| `Exception` | `godwit.clrex.EXException` |
| `ILGenerator` | `godwit.cil` |
| `IL↑` | `godwit.corhdr` `godwit.cor` |
| `IL↓` | `godwit.cil` |

| Godwit | C# |
|--------|----|
| `AppDomain*` | TBD (impossible?) |
| `Assembly*` | `*(nint*)&RuntimeAssembly` |
| `Module*` | `**(nint**)&Module.MethodHandle` |
| `MethodTable*` | `Type.TypeHandle.Value` |
| `MethodDesc*` | `MethodBase.MethodHandle.Value` |
| `FieldDesc*` | `FieldInfo.FieldHandle.Value` |
| `PCCOR_SIGNATURE` | `Signature.m_sig` |

## Usage

TBD

## Documentation

TBD

Some files, namely those which are not translated from CoreCLR, have had ddocs documentation made for them, but full documentation is not nearly close to completion.

## Contributions

Contributions are greatly appreciated. Godwit is a massive project and manning this on my own has been tremendously tedious.

Do whatever you want to contribute, ideally a pull request, but faxing the diff to me is also a viable option if you have time traveled to this timeline recently and have yet to adjust to modern technology.

### Issues

If you find any bugs or have any suggestions, please open an issue. Bugs will be my first priority but I will make sure that any reasonable suggestions get put on my TODO and will be gotten around to.

### Reference & Standards

Keep things simple, do not go overboard with OOP or anything of the like, and remember, composition over inheritance.

I've labeled all files and classes according to how they were named in the CoreCLR source code, with some exceptions. Any exceptions should have comments somewhere near the top or the type name indicating where it originally came from or what it represents.

Structures that don't accurately represent the original are okay, so long as it doesn't have any detriment, but I personally prefer to keep things as close to the original as possible.

NO DEPENDENCIES

## License

[MPL-2](/LICENSE.txt) 🎅🎅🎅
