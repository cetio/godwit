module godwit.backend.vm.eeclass;

import godwit.backend.vm.methodtable;
import godwit.backend.vm.method;
import godwit.backend.vm.field;
import godwit.backend.vm.stub;
import godwit.backend.vm.typehandle;
import godwit.backend.inc.corhdr;
import godwit.backend.vm.object;
import godwit.backend.packedfields;
import godwit.backend.inc.corinfo;
import godwit.impl;

public struct CCWTemplate
{
public:
final:
    ubyte* m_vtable;
    MethodTable* m_wrappedMethodTable;
    MethodDesc* m_wrappedMethodDesc;
    ubyte* m_mlHeader;
    ubyte* m_mlCode;
    MethodDescChunk* m_methodDescChunk;
    ubyte* m_ilCode;
    ubyte* m_extraInfo;
    MethodTable* m_interfaceMethodTable;

// mixin accessors;
}

public struct SparseVTableEntry
{
public:
final:
    ushort m_mtStart;
    ushort m_count;
    ushort m_vtStart;

// mixin accessors;
}

public struct SparseVTableMap
{
public:
final:
    SparseVTableEntry* m_entryMapList;
    ushort m_numMapEntries;
    ushort m_numAllocated;
    ushort m_lastUsedIndex;
    ushort m_vtSlot;
    ushort m_mtSlot;

// mixin accessors;
}

public struct LayoutInfo
{
public:
final:
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

// mixin accessors;
}

// fieldmarshaler.h
public struct NativeLayoutInfo
{
public:
final:
    ubyte m_alignmentReq;
    version (Posix)
    {
        bool m_passInRegisters;
    }
    static if (HFA)
    {
        CorInfoHFAElemType m_hfaType;
    }
    bool m_isMarshalable;
    ushort m_size;
    uint m_numFields;
    NativeFieldDescriptor* m_nativeFieldDescriptor;

// mixin accessors;
}

// fieldmarshaler.h
public struct NativeFieldDescriptor
{
public:
final:
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
    uint m_offset;
    NativeFieldCategory m_category;

// mixin accessors;
}

public struct OptionalFields
{
public:
final:
    void* m_dictLayout;
    ubyte* m_varianceInfo;

    static if (COM_INTEROP)
    {
        SparseVTableMap* m_sparseVTableMap;
        TypeHandle m_coClass;
        static if (COM_INTEROP_UNMANAGED_ACTIVATION)
        {
            void** m_classFactory;
        }
    }

    version (Posix)
    {
        ubyte m_numEightBytes;
        SystemVClassification[2] m_eightByteClassifications;
        ubyte[2] m_eightByteSizes;
    }

    ubyte m_requiredFieldAlignment;

// mixin accessors;
}

public struct EEClass
{
public:
final:
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
        Sealed = 0x00000100,
        SpecialName = 0x00000400,
        Import = 0x00001000,
        Serializable = 0x00002000,
        WindowsRuntime = 0x00004000,

        StringFormatMask = 0x00030000,
        kAnsiClass = 0x00000000,
        kUnicodeClass = 0x00010000,
        kAutoClass = 0x00020000,

        BeforeFieldInit = 0x00100000,

        ReservedMask = 0x00040800,
        kRTSpecialName = 0x00000800,
        kHasSecurity = 0x00040000
    }

    @flags enum VMFlags : uint
    {
        LayoutDependsOnOtherModules = 0x00000001,
        Delegate = 0x00000002,
        ENCStaticFields = 0x00000004,
        FixedAddressVtStatics = 0x00000020,
        HasLayout = 0x00000040,
        IsNested = 0x00000080,
        IsEquivalentType = 0x00000200,
        HasOverlayedFields = 0x00000400,
        HasFieldsWhichMustBeInited = 0x00000800,
        UnsafeValueType = 0x00001000,
        BestFitMappingInited = 0x00002000,
        BestFitMapping = 0x00004000,
        ThrowOnUnmappableChar = 0x00008000,
        InlineArray = 0x00010000,
        NoGuid = 0x00020000,
        HasRVAStaticFields = 0x00040000,
        HasCustomFieldAlignment = 0x00080000,
        ContainsStackPtr = 0x00100000,
        PreferAlign8 = 0x00200000,
        OnlyAbstractMethods = 0x00400000,
        SparseForCominterop = 0x00800000,
        HasCoClassAttrib = 0x01000000,
        ComEventItfMask = 0x02000000,
        VTableMethodImpl = 0x04000000,
        CovariantOverride = 0x08000000,
        NotTightlyPacked = 0x10000000,
        ContainsMethodImpls = 0x20000000,
    }

    GuidInfo* m_guidInfo;

    static if (DEBUG)
    {
        const(char)* debugClassName;
        bool debuggingClass;
    }

    OptionalFields* m_optionalFields;
    MethodTable* m_methodTable;
    FieldDesc* m_fieldDescList;
    MethodDescChunk* m_chunks;

    static if (COM_INTEROP)
    {
        CorInterfaceType m_comInterfaceType;
        void* m_ccwTemplate;
    }

    uint m_attrClass;
    uint m_vmFlags;

    static if (DEBUG)
    {
        ushort auxFlags;
    }

    ubyte m_normType;
    ubyte m_baseSizePadding;

    ushort m_numInstanceFields;
    ushort m_numMethods;
    ushort m_numStaticFields;
    ushort m_numHandleStatics;
    ushort m_numThreadStaticFields;
    ushort m_numHandleThreadStatics;
    ushort m_numNonVirtualSlots;

    uint m_nonGCStaticFieldBytes;
    uint m_nonGCThreadStaticFieldBytes;

// mixin accessors;

    uint numTotalFields()
    {
        return m_numInstanceFields + m_numStaticFields;
    }

    uint numInstanceFields()
    {
        return m_numInstanceFields;
    }

    uint numStaticFields()
    {
        return m_numStaticFields;
    }

    uint numThreadStaticFields()
    {
        return m_numThreadStaticFields;
    }

    uint numHandleStatics()
    {
        return m_numHandleStatics;
    }

    uint numHandleThreadStatics()
    {
        return m_numHandleThreadStatics;
    }

    uint numNonVirtualSlots()
    {
        return m_numNonVirtualSlots;
    }

    uint nonGCStaticFieldBytes()
    {
        return m_nonGCStaticFieldBytes;
    }

    uint nonGCThreadStaticFieldBytes()
    {
        return m_nonGCThreadStaticFieldBytes;
    }

    pragma(mangle, "EEClass_fields_get")
    extern (C) export FieldDesc*[] fields()
    {
        int length = numTotalFields();
        FieldDesc*[] fieldDescs;
        for (int i = 0; i < length; i++)
            fieldDescs ~= m_fieldDescList + i;
        return fieldDescs;
    }
}