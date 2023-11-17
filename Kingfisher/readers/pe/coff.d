module readers.pe.coff;

public struct COFFHeader
{
public:
  ushort machine;
  ushort numberOfSections; 
  uint timeDateStamp;
  uint pointerToSymbolTable;
  uint numberOfSymbols;
  ushort sizeOfOptionalHeader;
  ushort characteristics;
  COFFFields fields;
}

public struct COFFFields
{
public:
  ushort magic;
  ubyte majorLinkerVersion;
  ubyte minorLinkerVersion;
  uint sizeOfCode;
  uint sizeOfInitializedData;
  uint sizeOfUninitializedData;
  uint addressOfEntryPoint;
  uint baseOfCode;
}