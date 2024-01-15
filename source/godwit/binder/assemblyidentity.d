module godwit.assemblyidentity;

import godwit.sbuffer;
import godwit.assemblyversion;
import caiman.traits;

public struct AssemblyIdentity
{
public:
final:
    enum PEKind
    {
        None = 0x00000000,
        MSIL = 0x00000001,
        I386 = 0x00000002,
        IA64 = 0x00000003,
        AMD64 = 0x00000004,
        ARM = 0x00000005,
        ARM64 = 0x00000006,
        Invalid = 0xffffffff
    }

    enum AssemblyContentType
    {
        Default = 0,
        WindowsRuntime = 0x1,
        Invalid = 0xffffffff
    }

    @flags enum IdentityFlags
    {
        Empty = 0x000,
        SimpleName = 0x001,
        Version = 0x002,
        PublicKeyToken = 0x004,
        PublicKey = 0x008,
        Culture = 0x010,
        ProcessorArchitecture = 0x040,
        Retargetable = 0x080,
        PublicKeyTokenNull = 0x100,
        ContentType = 0x800,
        FullName = (SimpleName | Version)
    }

    SString m_simpleName;
    AssemblyVersion m_asmVersion;
    SString m_cultureOrLanguage;
    SBuffer m_publicKeyOrTokenBlob;
    PEKind m_cpuArchitecture;
    AssemblyContentType m_contentType;
    IdentityFlags m_identityFlags;

    mixin accessors;
}