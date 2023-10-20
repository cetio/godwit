module readers.packedfields;

public immutable struct PackedFields
{
public:
    /*
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
    uint GetUnpackedField(uint dwFieldIndex)
    {
        return (cast(uint*)&this)[dwFieldIndex];
    }

    /*
    * Get a packed field value at the specified field index.
    * 
    * Packed fields are stored as consecutive bits in the bit vector.
    * 
    * Params:
    *   - `dwFieldIndex`: The index of the field to retrieve.
    * 
    * Returns:
    *   The value of the packed field at the specified index.
    */
    uint GetPackedField(uint dwFieldIndex)
    {
        // Calculate the offset and length of the packed field.
        uint dwOffset = CalculateOffset(dwFieldIndex);
        uint dwFieldLength = BitVectorGet(dwOffset, MAX_LENGTH_BITS) + 1;

        // Extract and return the packed field value.
        return BitVectorGet(dwOffset + MAX_LENGTH_BITS, dwFieldLength);
    }

private:
    const int MAX_LENGTH_BITS = 5;
    const int BITS_PER_uint = 32;

    /*
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
    private uint CalculateOffset(uint dwFieldIndex)
    {
        uint dwOffset = 0;
        for (uint i = 0; i < dwFieldIndex; i++)
            dwOffset += MAX_LENGTH_BITS + BitVectorGet(dwOffset, MAX_LENGTH_BITS) + 1;

        return dwOffset;
    }

    /*
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
    private uint BitVectorGet(uint dwOffset, uint dwLength)
    {
        uint dwValueShift = dwOffset % BITS_PER_uint;
        uint dwValueMask = (1 << dwLength) - 1 << dwValueShift;

        return ((cast(uint*)&this)[dwOffset / BITS_PER_uint] & dwValueMask) >> dwValueShift;
    }
}
