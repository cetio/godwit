# Godwit

D-CoreCLR interop library, intended to allow D and other bound languages to interact with C# programs without any explicit back and forth between the languages. This is achieved by directly translating CoreCLR structures and code into D.

As of present, the interacting language must be initialized by C#, due to the constraint of not knowing where the `AppDomain` is located in memory.

## Support

Godwit is intended to have support for all of the things that `System.Reflection` in C# supports, including PE/metadata reading, assembly, disassembly, and execution of IL code.

However, until Godwit is near completion, implementation flags will not be fully supported, meaning that Godwit is incredibly volatile unless you can absolutely guarantee there is no mismatch.

### Equivalence

| C# | Godwit |
-----|--------|
| `AppDomain` | `godwit.appdomain.AppDomain` |
| `Assembly` | `godwit.assembly.Assembly` |
| `Module` | `godwit.ceeload.Module` |
| `Type` | `godwit.methodtable.MethodTable` |
| `TypeHandle` | `godwit.typehandle.TypeHandle` |
| `MethodBase` | `godwit.method.*MethodDesc` |
| `MethodInfo` | `godwit.method.*MethodDesc` |
| `ConstructorInfo` | `godwit.method.*MethodDesc` |
| `RuntimeMethodHandle` | `godwit.method.*MethodDesc` |
| `FieldInfo` | `godwit.field.FieldDesc` |
| `RuntimeFieldHandle` | `godwit.field.FieldDesc` |
| `Object` | `godwit.objects.BaseObject` |
| `Object*` | `godwit.objects.ObjectHandle` TBD |
| `Exception` | `godwit.clrex.EXException` |
| `IL↑` | `godwit.corhdr` `godwit.cor` |
| `IL↓` | `godwit.cil` |

## Usage

TBD

## Documentation

TBD

## Contributions

Contributions are greatly appreciated. Godwit is a massive project and manning this on my own has been tremendously tedious.

Do whatever you want to contribute, ideally a pull request, but faxing the diff to me is also a viable option if you have time traveled to this timeline recently and have yet to adjust to modern technology.

### Issues

If you find any bugs or have any suggestions, please open an issue. Bugs will be my first priority but I will make sure that any reasonable suggestions get put on my TODO and will be gotten around to.

### Reference & Standards

Keep things simple, do not go overboard with OOP or anything of the like, and remember, composition over inheritance.

I've labeled all files and classes according to how they were named in the CoreCLR source code, with some exceptions. Any exceptions should have comments somewhere near the top or the type name indicating where it originally came from or what it represents.

Structures that don't accurately represent the original are okay, so long as it doesn't have any detriment, but I personally prefer to keep things as close to the original as possible.

## License

Godwit is released under the MPL-2 license.