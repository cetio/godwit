module vm.eeclass;

import vm.methodtable;
import vm.method;
import vm.field;
import vm.stub;
import vm.typehandle;
import inc.corhdr;
import vm.objects;
import readers.packedfields;
import state;

public struct CCWTemplate
{
public:
    ubyte* m_vtable;
    MethodTable* m_wrappedMethodTable;
    MethodDesc* m_wrappedMethodDesc;
    ubyte* m_mlHeader;
    ubyte* m_mlCode;
    MethodDescChunk* m_methodDescChunk;
    ubyte* m_ilCode;
    ubyte* m_extraInfo;
    MethodTable* m_interfaceMethodTable;

    mixin accessors;
}

public struct SparseVTableEntry
{
public:
    ushort m_mtStart;
    ushort m_count;
    ushort m_vtStart;

    mixin accessors;
}

public struct SparseVTableMap
{
public:
    SparseVTableEntry* m_entryMapList;
    ushort m_numMapEntries;
    ushort m_numAllocated;
    ushort m_lastUsedIndex;
    ushort m_vtSlot;
    ushort m_mtSlot;

    mixin accessors;
}

public struct LayoutInfo
{
public:
    @flags enum LayoutFlags : ubyte
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

    uint m_managedSize;
    ubyte m_largestMemberAlignmentReq;
    LayoutFlags m_layoutFlags;
    ubyte m_packingSize;

    mixin accessors;
}

public struct NativeLayoutInfo
{
public:
    ubyte m_alignmentReq;
    bool m_isMarshalable;
    ushort m_size;
    uint m_numFields;
    NativeFieldDescriptor* m_nativeFieldDescriptor;

    mixin accessors;
}

public struct NativeFieldDescriptor
{
public:
    enum NativeFieldCategory : short
    {
        Float,
        Nested,
        Integer,
        Illegal
    }

    FieldDesc* m_fieldDesc;
    union
    {
        struct
        {
            MethodTable* m_nestedType;
            uint m_numNestedElements;
        }
        struct
        {
            uint m_nativeSize;
            uint m_numFieldElements;
        }
    }
    // layout is totally wrong from here onwards, I simply don't care enough
    uint m_offset; // offset 8
    NativeFieldCategory m_category; // offset 12

    mixin accessors;
}

public struct OptionalFields
{
public:
    ubyte* m_dictLayout;
    ubyte* m_varianceInfo;
    SparseVTableMap* m_sparseVTableMap;
    TypeHandle m_coClass;
    uint m_moduleDynamicID;
    ubyte m_requiredFieldAlignment;

    mixin accessors;
}

public struct EEClass
{
public:
    @flags enum TypeAttributes : uint
    {
        VisibilityMask = 0x00000007,
        kNotPublic = 0x00000000,
        kPublic = 0x00000001,
        kNestedPublic = 0x00000002,
        kNestedPrivate = 0x00000003,
        kNestedFamily = 0x00000004,
        kNestedAssembly = 0x00000005,
        kNestedFamANDAssem = 0x00000006,
        kNestedFamORAssem = 0x00000007,

        LayoutMask = 0x00000018,
        kAutoLayout = 0x00000000,
        kSequentialLayout = 0x00000008,
        kExplicitLayout = 0x00000010,

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
        kAnsiClass = 0x00000000,
        kUnicodeClass = 0x00010000,
        kAutoClass = 0x00020000,

        // Initialize the struct any time before first static field access.
        BeforeFieldInit = 0x00100000,

        ReservedMask = 0x00040800,
        // Runtime should check name encoding.
        kRTSpecialName = 0x00000800,
        kHasSecurity = 0x00040000
    }

    @flags enum VMFlags : uint
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
        kInhibit = 0x40000000,
        kFreeThreaded = 0x80000000,
        kStandard = 0xc0000000
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
    }

    GuidInfo* m_guidInfo;
    OptionalFields* m_optionalFields;
    MethodTable* m_methodTable;
    FieldDesc* m_fieldDescList;
    MethodDescChunk* m_methodDescChunk;
    union
    {
        ObjectHandle m_delegateObjectHandle;
        CorInterfaceType m_corInterfaceType;
    }
    CCWTemplate* m_ccwTemplate;
    TypeAttributes m_typeAttributes;
    VMFlags m_vmFlags;
    CorElementType m_corElementType;
    bool m_fieldsArePacked;
    ubyte m_fixedEEClassFields;
    ubyte m_baseSizePadding;
    union
    {
       struct
        {
            uint m_rank;
            CorElementType m_elemType;
        }

        Stub* m_staticCallStub;
        LayoutInfo m_layoutInfo;
    }
    union
    {
        Stub* m_instRetBuffCallStub;
        NativeLayoutInfo* m_nativeLayoutInfo;
    }
    MethodDesc* m_invokeMethod;
    Stub* m_multiCastInvokeStub;
    Stub* m_wrapperDelegateInvokeStub;
    UMThunkMarshInfo* m_umThunkMarshInfo;
    MethodDesc* m_beginInvokeMethod;
    MethodDesc* m_endInvokeMethod;
    ubyte* m_marshalStub;

    mixin accessors;

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