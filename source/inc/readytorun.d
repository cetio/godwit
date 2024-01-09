module godwit.readytorun;

import godwit.corhdr;
import godwit.collections.state;

public struct ReadyToRunCoreHeader
{
public:
    @flags enum Flags
    {
        // Set if the original IL assembly was platform-neutral
        PlatformNeutralSource = 0x00000001,   
        // Set of methods with native code was determined using profile data
        SkipTypeValidation = 0x00000002,   
        Partial = 0x00000004,
        // PInvoke stubs compiled into image are non-shareable (no secret parameter)
        NonsharedPInvokeStubs = 0x00000008,   
        // MSIL is embedded in the composite R2R executable
        EmbeddedMSIL = 0x00000010,   
        // This is the header describing a component assembly of composite R2R
        Component = 0x00000020,   
        // This R2R module has multiple modules within its version bubble (For versions before version 6.2, all modules are assumed to possibly have this characteristic)
        MultiModuleVersionBubble = 0x00000040,   
        // This R2R module has code in it that would not be naturally encoded into this module
        UnrelatedR2RCode = 0x00000080,   
    }

    Flags m_flags;
    uint m_numSections;

    mixin accessors;
}

public struct ReadyToRunHeader
{
public:
    uint m_signature;
    ushort m_major;
    ushort m_minor;
    ReadyToRunCoreHeader m_coreHeader;

    mixin accessors;
}

public struct ReadyToRunImportSection
{
public:
    enum SectionType : ubyte
    {
        Unknown      = 0,
        StubDispatch = 2,
        StringHandle = 3,
        ILBodyFixups = 7,
    }

    @flags enum SectionFlags : ushort
    {
        None     = 0x0000,
        // Section at module load time.
        Eager    = 0x0001, 
        // Section contains pointers to code
        PCode    = 0x0004, 
    }

    // Section containing values to be fixed up
    ImageDataDirectory m_section;
    // One or more of ReadyToRunImportSectionFlags
    SectionFlags m_flags;
    // One of ReadyToRunImportSectionType
    SectionType m_type;
    ubyte m_entrySize;
    // RVA of optional signature descriptors
    uint m_signatures;
    // RVA of optional auxiliary data (typically GC info)
    uint m_auxData;

    mixin accessors;
}