module godwit.formats;

import godwit.stream;
import godwit.pe.standard;
import godwit.pe.optional;

public class PE
{
private:
    Stream stream;

    void readDOSHeader() 
    {
        dosHeader = stream.read!DOSHeader;
    }

    void readCOFFHeader() 
    {
        stream.position = dosHeader.e_lfanew;
        coffHeader = stream.read!COFFHeader;
    }

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
    DOSHeader dosHeader;
    COFFHeader coffHeader;
    OptionalImage optionalImage;

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