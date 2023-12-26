module godwit.stream;

import std.file;
import std.conv;
import std.algorithm.mutation;
import std.algorithm : canFind;
import std.traits;

public enum Endianness : ubyte
{
    Native,
    LittleEndian,
    BigEndian
}

public enum Seek
{
    Start,
    Current,
    End
}

public class Stream
{
protected:
    ubyte[] data;
    bool filePath;

public:
    ulong position;
    Endianness endianness;

    this(ubyte[] data, Endianness endianness = Endianness.Native)
    {
        this.data = data;
        this.endianness = endianness;
    }

    this(string filePath, Endianness endianness = Endianness.Native)
    {
        this.data = cast(ubyte[])file.read(filePath);
        this.endianness = endianness;
        this.filePath = filePath;
    }

    bool mayRead()(int size = 1)
    {
        return position + size - 1 < data.length;
    }

    bool mayRead(T)()
    {
        return position + T.sizeof - 1 < data.length;
    }

    /**
    * Swaps the endianness of the provided value, if applicable.
    *
    * Params:
    *     val = The value to swap endianness.
    *
    * Returns:
    *   The value with swapped endianness.
    */
    T makeEndian(T)(T val)
    {
        version (LittleEndian)
        {
            if (endianness == Endianness.BigEndian)
            {
                ubyte[] bytes = (cast(ubyte*)&val)[0..T.sizeof];
                bytes = bytes.reverse();
                val = *cast(T*)&bytes[0];
            }
        }
        else version (BigEndian)
        {
            if (endianness == Endianness.LittleEndian)
            {
                ubyte[] bytes = (cast(ubyte*)&val)[0..T.sizeof];
                bytes = bytes.reverse();
                val = *cast(T*)&bytes[0];
            }
        }

        return val;
    }

    /**
    * Moves the position in the stream by the size of type T.
    *
    * Params:
    *     T = The size of type to move the position by.
    */
    @nogc void step(T)()
    {
        position += T.sizeof;
    }

    /**
    * Moves the position in the stream by the size of type T * elements.
    *
    * Params:
    *     T = The size of type to move the position by.
    *     count = The number of elements.
    */
    @nogc void step(T)(int count)
    {
        position += T.sizeof * count;
    }

    /**
    * Seeks to a new position in the stream based on the provided offset and seek direction.
    * Does not work like a conventional seek, and will read type T from the stream, using that as the seek offset.
    *
    * Params:
    *     T = The offset value for seeking.
    *     SEEK = The direction of the seek operation (Start, Current, or End).
    */
    @nogc void seek(T, Seek SEEK)()
        if (isIntegral!T)
    {
        static if (SEEK == Seek.Start)
        {
            position = read!T();
        }
        else if (SEEK == Seek.Current)
        {
            position += read!T();
        }
        else
        {
            position = data.length - read!T();
        }
    }

    /**
    * Reads the next value from the stream of type T.
    *
    * Params:
    *     T = The type of data to be read.
    *
    * Returns:
    *   The value read from the stream.
    */
    @nogc T read(T)()
    {
        scope(exit) step!T();
        return peek!T();
    }

    /**
    * Peeks at the next value from the stream of type T without advancing the stream position.
    *
    * Params:
    *     T = The type of data to peek.
    *
    * Returns:
    *   The value peeked from the stream.
    */
    @nogc T peek(T)()
    {
        if (data.length <= position)
            return cast(T)0;

        T val = *cast(T*)(&data[position]);
        return makeEndian!T(val);
    }

    /**
    * Writes the provided value to the stream.
    *
    * Params:
    *     T = The type of data to be written.
    *     val = The value to be written to the stream.
    */
    @nogc void write(T)(T val)
    {
        scope(exit) step!T();
        put!T(val);
    }

    /**
    * Writes the provided value to the stream without advancing the stream position.
    *
    * Params:
    *     T = The type of data to be written.
    *     val = The value to be written to the stream.
    */
    @nogc void put(T)(T val)
    {
        if (data.length <= position)
            return;

        val = makeEndian!T(val);
        *cast(T*)(&data[position]) = val;
    }

    /**
    * Reads multiple values of type T from the stream.
    *
    * Params:
    *     T = The type of data to be read.
    *     count = The number of values to read from the stream.
    *
    * Returns:
    *   An array of values read from the stream.
    */
    T[] read(T)(int count)
    {
        T[] items;
        foreach (ulong i; 0..count)
            items ~= read!T();
        return items;
    }

    /**
    * Peeks at multiple values of type T from the stream without advancing the stream position.
    *
    * Params:
    *     T = The type of data to peek.
    *     count = The number of values to peek from the stream.
    *
    * Returns:
    *   An array of values peeked from the stream.
    */
    T[] peek(T)(int count)
    {
        ulong _position = position;
        scope(exit) position = _position;
        return read!T(count);
    }

    /**
    * Writes multiple values of type T to the stream.
    *
    * Params:
    *     T = The type of data to be written.
    *     items = An array of values to be written to the stream.
    */
    @nogc void write(T)(T[] items)
    {
        foreach (ulong i; 0..items.length)
            write!T(items[i]);
    }

    /**
    * Writes multiple values of type T to the stream without advancing the stream position.
    *
    * Params:
    *     T = The type of data to be written.
    *     items = An array of values to be written to the stream.
    */
    @nogc void put(T)(T[] items)
    {
        ulong _position = position;
        scope(exit) position = _position;
        write!T(items);
    }

    /**
    * Reads a string from the stream considering the character width and prefixing.
    *
    * Params:
    *     CHAR = The character type used for reading the string (char, wchar, or dchar).
    *     PREFIXED = Indicates whether the string is prefixed. Default is false.
    *
    * Returns:
    *   The read string from the stream.
    */
    string readString(CHAR, bool PREFIXED = false)()
        if (is(CHAR == char) || is(CHAR == dchar) || is(CHAR == wchar))
    {
        static if (PREFIXED)
            return read!CHAR(read7EncodedInt()).to!string;

        string str = (cast(CHAR*)(&data[position])).to!string;
        position += str.length * CHAR.sizeof;
        return makeEndian!string(str);
    }

    /**
    * Reads a string from the stream considering the character width and prefixing without advancing the stream position.
    *
    * Params:
    *     CHAR = The character type used for reading the string (char, wchar, or dchar).
    *     PREFIXED = Indicates whether the string is prefixed. Default is false.
    *
    * Returns:
    *   The read string from the stream.
    */
    string peekString(CHAR, bool PREFIXED = false)()
        if (is(CHAR == char) || is(CHAR == dchar) || is(CHAR == wchar))
    {
        static if (PREFIXED)
        {
            ulong _position = position;
            scope(exit) position = _position;
            return readString!(CHAR, PREFIXED)();
        }
        
        string str = (cast(CHAR*)(&data[position])).to!string;
        return makeEndian!string(str);
    }

    /**
    * Writes a string to the stream considering the character width and prefixing.
    *
    * Params:
    *     CHAR = The character type used for writing the string (char, wchar, or dchar).
    *     PREFIXED = Indicates whether the string is prefixed. Default is false.
    *     str = The string to be written to the stream.
    */
    void writeString(CHAR, bool PREFIXED = false)(string str)
        if (is(CHAR == char) || is(CHAR == dchar) || is(CHAR == wchar))
    {
        static if (PREFIXED)
        {
            write7EncodedInt(cast(int)str.length);
        }
        else if (str.length > 0 && str[$ - 1] != '\0')
        {
            str ~= '\0';
        }

        write!CHAR(str.dup.to!(CHAR[]));
    }

    /**
    * Writes a string into the stream considering the character width and prefixing without advancing the stream position.
    *
    * Params:
    *     CHAR = The character type used for writing the string (char, wchar, or dchar).
    *     PREFIXED = Indicates whether the string is prefixed. Default is false.
    *     str = The string to be put into the stream.
    */
    void putString(CHAR, bool PREFIXED = false)(string str)
        if (is(CHAR == char) || is(CHAR == dchar) || is(CHAR == wchar))
    {
        static if (PREFIXED)
        {
            ulong _position = position;
            scope(exit) position = _position;
            write7EncodedInt(cast(int)str.length);
        }
        else if (str.length > 0 && str[$ - 1] != '\0')
        {
            str ~= '\0';
        }
           
        put!CHAR(str.dup.to!(CHAR[]));
    }

    /**
    * Reads an integer value encoded in 7 bits from the stream.
    *
    * Returns:
    *   The integer value read from the stream.
    */
    @nogc int read7EncodedInt()
    {
        int result = 0;
        int shift = 0;

        foreach (int i; 0..5)
        {
            ubyte b = read!ubyte();
            result |= cast(int)(b & 0x7F) << shift;
            if ((b & 0x80) == 0)
                return result;
            shift += 7;
        }
        
        return result;
    }

    /**
    * Writes an integer value encoded in 7 bits to the stream.
    *
    * Params:
    *     val = The integer value to be written to the stream.
    */
    @nogc void write7EncodedInt(int val)
    {
        foreach (int i; 0..5)
        {
            byte b = cast(byte)(val & 0x7F);
            val >>= 7;
            if (val != 0)
                b |= 0x80;
            write!ubyte(b);
            if (val == 0)
                return;
        }
    }

    /**
    * Reads a type from the stream using optional fields.
    *
    * Params:
    *     TO = The type to be read from the stream.
    *     ARGS... = The arguments for optional fields.
    *
    * Returns:
    *   The read type read from the stream.
    */
    TO readPlasticized(TO, ARGS...)()
        if (ARGS % 3 == 0)
    {
        TO val = read!(TO)();
        string field;
        string conditionalField;
        foreach (i, ARG; ARGS)
        {
            if (i % 3 == 0)
            {
                static assert(is(typeof(ARG) : string),
                          "Field name expected, found " ~ ARG.stringof);

                field = ARG;
            }
            else if (i % 3 == 1)
            {
                static assert(is(typeof(ARG) : string),
                          "Conditional field name expected, found " ~ ARG.stringof);

                conditionalField = ARG;
            }
            else
            {
                if (__traits(getMember, val, conditionalField) != ARG)
                {
                    __traits(getMember, val, field) = __traits(getMember, val, field).init;
                    position -= __traits(getMember, val, field).sizeof;
                }
            }
        }
    }

    /**
    * Reads a type from the stream without advancing the stream position and using optional fields.
    *
    * Params:
    *     TO = The type to be read from the stream.
    *     ARGS... = The arguments for optional fields.
    *
    * Returns:
    *   The read type read from the stream.
    */
    TO peekPlasticized(TO, ARGS...)()
        if (ARGS % 3 == 0)
    {
        ulong _position = position;
        scope(exit) position = _position;
        return readPlasticized!(TO, ARGS)();
    }

    /**
    * Writes a type to the stream using optional fields.
    *
    * Params:
    *     TO = The type to be read from the stream.
    *     ARGS... = The arguments for optional fields.
    *
    * Returns:
    *   The read type read from the stream.
    */
    void writePlasticized(FROM, ARGS...)(FROM val)
        if (ARGS % 3 == 0)
    {
        string conditionalField;
        foreach (string field; FieldNameTuple!FROM)
        {
            foreach (i, ARG; ARGS)
            {
                if (i % 3 == 0)
                {
                    static assert(is(typeof(ARG) : string),
                        "Field name expected, found " ~ ARG.stringof);

                    if (ARG != field)
                        continue;
                }
                else if (i % 3 == 1)
                {
                    static assert(is(typeof(ARG) : string),
                        "Conditional field name expected, found " ~ ARG.stringof);

                    conditionalField = ARG;
                }
                else
                {
                    if (__traits(getMember, val, conditionalField) == ARG)
                        write!(typeof(__traits(getMember, val, field)))(__traits(getMember, val, field));
                }
            }
        }
    }

    /**
    * Writes a type to the stream using optional fields and without forwarding the position.
    *
    * Params:
    *     TO = The type to be read from the stream.
    *     ARGS... = The arguments for optional fields.
    *
    * Returns:
    *   The read type read from the stream.
    */
    void putPlasticized(FROM, ARGS...)(FROM val)
        if (ARGS % 3 == 0)
    {
        string conditionalField;
        foreach (string field; FieldNameTuple!FROM)
        {
            foreach (i, ARG; ARGS)
            {
                if (i % 3 == 0)
                {
                    static assert(is(typeof(ARG) : string),
                                  "Field name expected, found " ~ ARG.stringof);

                    if (ARG != field)
                        continue;
                }
                else if (i % 3 == 1)
                {
                    static assert(is(typeof(ARG) : string),
                                  "Conditional field name expected, found " ~ ARG.stringof);

                    conditionalField = ARG;
                }
                else
                {
                    if (__traits(getMember, val, conditionalField) == ARG)
                        put!(typeof(__traits(getMember, val, field)))(__traits(getMember, val, field));
                }
            }
        }
    }

    void flush()
    {
        if (filePath != null)
            file.write(filePath, data);
    }
}