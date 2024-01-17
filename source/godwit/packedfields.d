/// Provides interface for reading EEClass field data
module godwit.packedfields;

/// Reader for EEClass packed (and unpacked) fields \
/// Credit to: https://github.com/Decimation for the structure (NeoCore iirc)
public immutable struct PackedFields
{
public:
final:
    /**
    * Get an unpacked field value at the specified field index.
    * 
    * Unpacked fields are individual fields within the bit vector.
    * 
    * Params:
    *   - `dwFieldIndex`: The index of the field to retrieve.
    * 
    * Returns:
    *   The value of the unpacked field at the specified index.
    */
    @nogc uint getUnpackedField(uint dwFieldIndex)
        scope return
    {
        return (cast(uint*)&this)[dwFieldIndex];
    }

    /**
    * Get a packed field value at the specified field index.
    * 
    * Packed fields are stored as consecutive bits in the bit vector.
    * 
    * Params:
    *  `dwFieldIndex`: The index of the field to retrieve.
    * 
    * Returns:
    *   The value of the packed field at the specified index.
    */
    @nogc uint getPackedField(uint dwFieldIndex)
    {
        // Calculate the offset and length of the packed field.
        uint dwOffset = calculateOffset(dwFieldIndex);
        uint dwFieldLength = bitVectorGet(dwOffset, MAX_LENGTH_BITS) + 1;

        // Extract and return the packed field value.
        return bitVectorGet(dwOffset + MAX_LENGTH_BITS, dwFieldLength);
    }

private:
    const int MAX_LENGTH_BITS = 5;
    const int BITS_PER_UINT = 32;

    /**
    * Calculate the offset of a field within the bit vector.
    * 
    * The offset is the position within the bit vector where the field starts.
    * 
    * Params:
    *   - `dwFieldIndex`: The index of the field to calculate the offset for.
    * 
    * Returns:
    *   The offset of the specified field within the bit vector.
    */
    @nogc uint calculateOffset(uint dwFieldIndex)
    {
        uint dwOffset = 0;
        for (uint i = 0; i < dwFieldIndex; i++)
            dwOffset += MAX_LENGTH_BITS + bitVectorGet(dwOffset, MAX_LENGTH_BITS) + 1;

        return dwOffset;
    }

    /**
    * Get the value of a bit vector at a specific offset and length.
    * 
    * This function extracts and returns the value of a specific portion of the bit vector.
    * 
    * Params:
    *   - `dwOffset`: The starting offset within the bit vector.
    *   - `dwLength`: The length of the portion to extract.
    * 
    * Returns:
    *   The extracted value from the bit vector.
    */
    @nogc uint bitVectorGet(uint dwOffset, uint dwLength)
        scope return
    {
        uint dwValueShift = dwOffset % BITS_PER_UINT;
        uint dwValueMask = (1 << dwLength) - 1 << dwValueShift;

        return ((cast(uint*)&this)[dwOffset / BITS_PER_UINT] & dwValueMask) >> dwValueShift;
    }
}
