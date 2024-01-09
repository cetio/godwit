/// Support for handling PE and ELF formats.
// TODO: ELF
module godwit.formats.exec;

import godwit.mem.stream;
import godwit.formats;

/**
 * Represents a PE file, providing methods to read its headers and optional image data.
 */
 // TODO: DataDirectory & metadata
public class PE
{
private:
    /// The stream used for reading the PE file.
    Stream stream;

    /// Reads the DOS header of the PE file.
    void readDOSHeader() 
    {
        dosHeader = stream.read!DOSHeader;
    }

    /// Reads the COFF header of the PE file.
    void readCOFFHeader() 
    {
        stream.position = dosHeader.e_lfanew;
        coffHeader = stream.read!COFFHeader;
    }

    /// Reads the optional image data of the PE file.
    void readOptionalImage() 
    {
        if (coffHeader.sizeOfOptionalHeader == 0)
            return;
            
        ImageType type = stream.peek!ImageType;

        if (type == ImageType.ROM)
        {
            *cast(ROMImage*)&optionalImage = stream.read!ROMImage;
        }
        else if (type == ImageType.PE32)
        {
            *cast(PE32Image*)&optionalImage = stream.read!PE32Image;
        }
        else if (type == ImageType.PE64)
        {
            *cast(PE64Image*)&optionalImage = stream.readPlasticized!(PE64Image, "baseOfData", "type", ImageType.PE32);
        }
    }

public:
    /// The DOS header of the PE file.
    DOSHeader dosHeader;
    /// The COFF header of the PE file.
    COFFHeader coffHeader;
    /// The optional image data of the PE file.
    OptionalImage optionalImage;

    /**
    * Reads a PE file from the specified file path.
    *
    * Params:
    *   - `filePath`: The path to the PE file to be read.
    *
    * Returns:
    *   A PE object containing the parsed data from the file.
    */
    static PE read(string filePath)
    {
        PE pe = new PE();
        pe.stream = new Stream(filePath);

        pe.readDOSHeader();
        pe.readCOFFHeader();
        pe.readOptionalImage();

        return pe;
    }
}