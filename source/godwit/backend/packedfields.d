/// Provides interface for reading EEClass field data
module godwit.backend.packedfields;

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
    *   - `fieldIndex`: The index of the field to retrieve.
    *
    * Returns:
    *   The value of the unpacked field at the specified index.
    */
    @nogc uint getUnpackedField(uint fieldIndex)
        scope return
    {
        return (cast(uint*)&this)[fieldIndex];
    }

    /**
    * Get a packed field value at the specified field index.
    *
    * Packed fields are stored as consecutive bits in the bit vector.
    *
    * Params:
    *  `fieldIndex`: The index of the field to retrieve.
    *
    * Returns:
    *   The value of the packed field at the specified index.
    */
    @nogc uint getPackedField(uint fieldIndex)
    {
        // Calculate the offset and length of the packed field.
        uint offset = calculateOffset(fieldIndex);
        uint fieldLength = bitVectorGet(offset, MAX_LENGTH_BITS) + 1;

        // Extract and return the packed field value.
        return bitVectorGet(offset + MAX_LENGTH_BITS, fieldLength);
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
    *   - `fieldIndex`: The index of the field to calculate the offset for.
    *
    * Returns:
    *   The offset of the specified field within the bit vector.
    */
    @nogc uint calculateOffset(uint fieldIndex)
    {
        uint offset = 0;
        for (uint i = 0; i < fieldIndex; i++)
            offset += MAX_LENGTH_BITS + bitVectorGet(offset, MAX_LENGTH_BITS) + 1;

        return offset;
    }

    /**
    * Get the value of a bit vector at a specific offset and length.
    *
    * This function extracts and returns the value of a specific portion of the bit vector.
    *
    * Params:
    *   - `offset`: The starting offset within the bit vector.
    *   - `length`: The length of the portion to extract.
    *
    * Returns:
    *   The extracted value from the bit vector.
    */
    @nogc uint bitVectorGet(uint offset, uint length)
        scope return
    {
        uint valueShift = offset % BITS_PER_UINT;
        uint valueMask = (1 << length) - 1 << valueShift;

        return ((cast(uint*)&this)[offset / BITS_PER_UINT] & valueMask) >> valueShift;
    }
}
