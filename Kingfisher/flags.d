module flags;

public:
static:
bool HasFlag(T)(T value, T flag)
{
    return (value & flag) != 0;
}

bool HasFlagMasked(T)(T value, T mask, T flag)
{
    return (value & mask) == flag;
}

void SetFlag(T)(ref T value, T flag, bool state)
{
    value = cast(T)(state ? (value | flag) : (value & ~flag));
}

void ToggleFlag(T)(ref T value, T mask)
{
    value = cast(T)(value ^ flag);
}

void SetFlagMasked(T)(ref T value, T mask, T flag, bool state)
{
    value = cast(T)(state ? (value & mask) | flag : (value & mask) & ~flag);
}

void ToggleFlagMasked(T)(ref T value, T mask, T flag)
{
    value = cast(T)((value & mask) ^ flag);
}

void ClearMask(T)(ref T value, T mask)
{
    value = cast(T)(value & ~mask);
}