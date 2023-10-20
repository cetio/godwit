module vm.eeclass;

import vm.methodtable;
import vm.method;
import vm.field;
import vm.stub;
import vm.typehandle;
import inc.corhdr;
import vm.objects;
import readers.packedfields;

extern (C) export uint GetFieldCount(MethodTable* pmt)
{
    return pmt.eeClass.numTotalFields();
}

extern (C) export FieldDesc* GetField(MethodTable* pmt, int index)
{
    return pmt.eeClass.getFields()[index];
}

public struct CCWTemplate
{
public:
    ubyte* vtable;
    MethodTable* wrappedMethodTable;
    MethodDesc* wrappedMethodDesc;
    ubyte* mlHeader;
    ubyte* mlCode;
    MethodDescChunk* methodDescChunk;
    ubyte* ilCode;
    ubyte* extraInfo;
    MethodTable* interfaceMethodTable;
}

public struct SparseVTableEntry
{
public:
    ushort mtStart;
    ushort count;
    ushort vtStart;
}

public struct SparseVTableMap
{
public:
    SparseVTableEntry* entryMapList;
    ushort numMapEntries;
    ushort numAllocated;
    ushort lastUsedIndex;
    ushort vtSlot;
    ushort mtSlot;
}

public struct LayoutInfo
{
public:
    enum LayoutFlags : ubyte
    {
        // TRUE if the GC layout of the struct is bit-for-bit identical
        // to its unmanaged counterpart with the runtime marshalling system
        // (i.e. no internal reference fields, no ansi-unicode char conversions required, etc.)
        // Used to optimize marshaling.
        Blittable = 0x01,
        // Is this type also sequential in managed memory?
        ManagedSequential = 0x02,
        // When a sequential/explicit type has no fields, it is conceptually
        // zero-sized, but actually is 1 byte in length. This holds onto this
        // fact and allows us to revert the 1 byte of padding when another
        // explicit type inherits from this type.
        ZeroSized = 0x04,
        // The size of the struct is explicitly specified in the meta-data.
        HasExplicitSize = 0x08,
        // Whether a native struct is passed in registers.
        NativePassInRegisters = 0x10,
        // The type recursively has a field that is LayoutKind.Auto and not an enum.
        HasAutoLayoutFieldInLayout = 0x10,
        // Type type recursively has a field which is an Int128
        IsOrHasInt128Field = 0x20
    }

    uint managedSize;
    ubyte largestMemberAlignmentReq;
    LayoutFlags layoutFlags;
    ubyte packingSize;
}

public struct NativeLayoutInfo
{
public:
    ubyte alignmentReq;
    bool isMarshalable;
    ushort size;
    uint numFields;
    NativeFieldDescriptor* nativeFieldDescriptor;
}

public struct NativeFieldDescriptor
{
public:
    enum NativeFieldCategory : short
    {
        FLOAT,
        NESTED,
        INTEGER,
        ILLEGAL
    }

    FieldDesc* fieldDesc;
    union
    {
       struct
        {
            MethodTable* nestedType;
            uint numNestedElements;
        }
       struct
        {
            uint nativeSize;
            uint numFieldElements;
        }
    }
    // layout is totally wrong from here onwards, I simply don't care enough
    uint offset; // offset 8
    NativeFieldCategory category; // offset 12
}

public struct OptionalFields
{
public:
    ubyte* dictLayout;
    ubyte* varianceInfo;
    SparseVTableMap* sparseVTableMap;
    TypeHandle coClass;
    uint moduleDynamicID;
    ubyte requiredFieldAlignment;
}

public struct EEClass
{
public:
    enum TypeAttributes : uint
    {
        VisibilityMask = 0x00000007,
        NotPublic = 0x00000000,
        Public = 0x00000001,
        NestedPublic = 0x00000002,
        NestedPrivate = 0x00000003,
        NestedFamily = 0x00000004,
        NestedAssembly = 0x00000005,
        NestedFamANDAssem = 0x00000006,
        NestedFamORAssem = 0x00000007,

        LayoutMask = 0x00000018,
        AutoLayout = 0x00000000,
        SequentialLayout = 0x00000008,
        ExplicitLayout = 0x00000010,

        Abstract = 0x00000080,
        // Class is concrete and may not be extended.
        Sealed = 0x00000100,
        SpecialName = 0x00000400,
        // Class/interface is imported.
        Import = 0x00001000,
        Serializable = 0x00002000,
        // Type is a Windows Runtime type.
        WindowsRuntime = 0x00004000,

        StringFormatMask = 0x00030000,
        AnsiClass = 0x00000000,
        UnicodeClass = 0x00010000,
        AutoClass = 0x00020000,

        // Initialize the struct any time before first static field access.
        BeforeFieldInit = 0x00100000,
        ReservedMask = 0x00040800,
        // Runtime should check name encoding.
        RTSpecialName = 0x00000800,
        HasSecurity = 0x00040000
    }

    enum VMFlags : uint
    {
        LayoutDependsOnOtherModules = 0x00000001,
        // This EEClass represents a DelegateClass.
        Delegate = 0x00000002,
        FixedAddressVtStatics = 0x00000020,
        HasLayout = 0x00000040,

        IsNested = 0x00000080,
        IsEquivalentType = 0x00000200,
        HasOverlayedFields = 0x00000400,
        // Contains static fields.
        HasFieldsWhichMustBeInited = 0x00000800,
        UnsafeValueType = 0x00001000,

        BestFitMappingInited = 0x00002000,
        BestFitMapping = 0x00004000,
        ThrowOnUnmappableChar = 0x00008000,

        // GuidInfo does exist but does not contain a Guid.
        NoGuid = 0x00020000,
        HasNonPublicFields = 0x00040000,
        ContainsStackPtr = 0x00100000,
        PreferAlign8 = 0x00200000,

        SparseForCominterop = 0x00800000,
        HasCoClassAttrib = 0x01000000,
        ComEventItfMask = 0x02000000,
        ProjectedFromWinRT = 0x04000000,
        ExportedToWinRT = 0x08000000,

        // Fields are packed but not tightly.
        NotTightlyPacked = 0x10000000,
        ContainsMethodImpls = 0x20000000,

        MarshalingTypeMask = 0xc0000000,
        MarshalingTypeInhibit = 0x40000000,
        MarshalingTypeFreeThreaded = 0x80000000,
        MarshalingTypeStandard = 0xc0000000
    }

    enum EEClassFieldId
    {
        NumInstanceFields,
        NumMethods,
        NumStaticFields,
        NumHandleStatics,
        NumBoxedStatics,
        NonGCStaticFieldBytes,
        NumThreadStaticFields,
        NumHandleThreadStatics,
        NumBoxedThreadStatics,
        NonGCThreadStaticFieldBytes,
        NumNonVirtualSlots
    };

    GuidInfo* guidInfo;
    OptionalFields* optionalFields;
    MethodTable* methodTable;
    FieldDesc* fieldDescList;
    MethodDescChunk* methodDescChunk;
    union
    {
        ObjectHandle delegateObjectHandle;
        CorInterfaceType corInterfaceType;
    }
    CCWTemplate* ccwTemplate;
    TypeAttributes typeAttributes;
    VMFlags vmFlags;
    CorElementType corElementType;
    bool fieldsArePacked;
    ubyte fixedEEClassFields;
    ubyte baseSizePadding;
    union
    {
       struct
        {
            uint rank;
            CorElementType elemCorElementType;
        }

        Stub* staticCallStub;
        LayoutInfo layoutInfo;
    }
    union
    {
        Stub* instRetBuffCallStub;
        NativeLayoutInfo* nativeLayoutInfo;
    }
    MethodDesc* invokeMethod;
    Stub* multiCastInvokeStub;
    Stub* wrapperDelegateInvokeStub;
    UMThunkMarshInfo* umThunkMarshInfo;
    MethodDesc* beginInvokeMethod;
    MethodDesc* endInvokeMethod;
    ubyte* marshalStub;

    public PackedFields* getPackedFields() 
        scope return
    {
        return cast(PackedFields*)(cast(byte*)&this + fixedEEClassFields);
    }

    public uint getPackedField(EEClassFieldId fieldId)
    {
        return fieldsArePacked 
            ? getPackedFields().GetPackedField(fieldId) 
            : getPackedFields().GetUnpackedField(fieldId);
    }

    public uint numTotalFields()
    {
        return getPackedField(EEClassFieldId.NumInstanceFields) 
            + getPackedField(EEClassFieldId.NumStaticFields);
    }

    public uint numInstanceFields()
    {
        return getPackedField(EEClassFieldId.NumInstanceFields);
    }

    public uint numStaticFields()
    {
        return getPackedField(EEClassFieldId.NumStaticFields);
    }

    public FieldDesc*[] getFields()
    {
        int length = numTotalFields();
        FieldDesc*[] fieldDescs = new FieldDesc*[length];

        for (int i = 0; i < length; i++)
            fieldDescs[i] = fieldDescList + i;

        return fieldDescs;
    }
}