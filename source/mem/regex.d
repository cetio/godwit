module godwit.mem.regex;

import std.typecons;
import std.bitmanip;
import std.string;
import std.conv;
import std.ascii;
import std.algorithm;
import std.datetime;
import std.regex;

public enum : ubyte
{
    BAD,
    /// `(?...)`
    /// Matches group ahead
    LOOK_AHEAD,
    /// `(...<...)`
    /// Matches group behind
    LOOK_BEHIND,
    /// `[...]`
    /// Stores a set of characters (matches any)
    CHARACTERS,
    /// `^`
    /// Matches only if at the start of a line or the full text
    ANCHOR_START,
    /// `$`
    /// Matches only if at the end of a line or the full text
    ANCHOR_END,
    /// `(...)`
    /// Stores a set of elements
    GROUP,
    /// `.`
    /// Matches any character
    ANY,
    /// ~`\gn`~ or `$n` (group) or `%n` (absolute)
    /// Refers to a group or element
    REFERENCE,
    // Not used! Comments don't need to be parsed!
    // (?#...)
    //COMMENT
    /// `\K` `\Kn`
    /// Resets match or group match
    RESET,
    /// `n->` or `|->`
    /// Moves the current text position forward
    PUSHFW,
    /// `<-n` or `<-|`
    /// Moves the current text position backward
    PUSHBW
}

public enum : ubyte
{
    /// No special rules, matches until the next element can match
    NONE = 0,
    /// `|`
    /// If fails, the next element will attempt to match instead
    ALTERNATE = 1,
    /// `[^...]`
    /// Matches only if no characters in the set match
    EXCLUSIONARY = 2,
    /// `{...}`
    /// Has min/max
    QUANTIFIED = 4,
    // *
    //GREEDY = 8,
    // +
    //MANY = 16,
    // ?
    //OPTIONAL = 32,
    // Now defaults to POSITIVE/CAPTURE if set to NONE
    // (...=...)
    // Also (...) (capture group)
    //CAPTURE = 64,
    //POSITIVE = 64,
    /// `(?:...)`
    /// Acts as a group but does not capture match
    NONCAPTURE = 8,
    /// `(...!...)`
    /// Matches if not matched
    NEGATIVE = 8,
    /// `...?`
    /// Matches as few times as possible
    LAZY = 8,
    /// `...+`
    /// Matches as many times as possible
    GREEDY = 16
}

public enum : ubyte
{
    /// Match more than once
    GLOBAL = 2,
    /// ^ & $ match start & end
    MULTILINE = 4,
    /// Case insensitive
    INSENSITIVE = 8,
    /// Ignore whitespace
    EXTENDED = 16,
    /// . matches \r\n\f
    SINGLELINE = 32
}

private struct Element
{
public:
align(1):
    /// What kind of element is this?
    /// eg: `CHARACTERS`
    ubyte token;
    /// What are the special modifiers of this element?
    /// eg: `EXCLUSIONARY`
    ubyte modifiers;
    /// Characters mapped (like in a character set or literal)
    /// Elements mapped (like in a group or reference)
    union
    {
        string str;
        Element[] elements;
    }
    /// Minimum times to require fulfillment
    /// eg: `1`
    uint min;
    /// Maximum times to allow fulfillment
    /// eg: `1`
    uint max;

    /++
        Checks if the requirements of this element can be fulfilled in the given text.
        
        Params:
        - `elements`: An array of elements defining the pattern to match.
        - `next`: An unsigned integer representing the next element to check.
        - `table`: A character array used for matching specific characters.
        - `flags`: An unsigned byte containing flags for various matching conditions.
        - `text`: The string in which the pattern is being searched.
        - `idx`: A reference to an unsigned integer indicating the current index in the text.

        Returns:
            A boolean indicating if the requirements of this element can be fulfilled in the given text.

        Remarks:
            This function recursively checks elements against the provided text to determine if the pattern is fulfilled.
            May modify `idx`.

        Example:
            ```d
            Element[] elements = [/*...*/];
            uint i = 0;
            uint next = 1;
            ubyte flags = 0;
            string text = "example text";
            bool result = fulfilled(elements, next, flags, text, i);
            ```
    +/
    pragma(inline, true);
    pure bool fulfilled(Element[] glob, uint next, ubyte flags, string text, ref uint i)
    {
        const bool hitNext = next < glob.length && (modifiers & GREEDY) == 0 && (modifiers & LAZY) == 0;
        foreach (k; 0..(max == 0 ? 1 : max)) 
        {
            // Match as little as possible
            if ((modifiers & LAZY) != 0 && k >= min)
                return true;
            
            // Try to see if the next element can be fulfilled yet
            uint ti = i + 1;
            if (hitNext && k >= min && glob[next].fulfilled(glob, next + 1, flags, text, ti))
            {
                i = ti - 1;
                return true;
            }

            if (k != 0)
                i++;

            if (token != ANCHOR_END && i >= text.length)
                return k >= min;

            switch (token) 
            {
                case LOOK_AHEAD:
                    uint ci = i - 1;
                    foreach (j; 0..elements.length) 
                    {
                        if (!elements[j].fulfilled(glob, next, flags, text, i)) 
                        {
                            if (k >= min)
                                i = ci;

                            return k >= min;
                        }
                    }
                    break;

                case LOOK_BEHIND:
                    return false;

                case CHARACTERS:
                    bool match = false;
                    foreach (j; 0..str.length) 
                    {
                        if (str[j] == text[i])
                            match = true;
                    }
                    
                    if (((modifiers & EXCLUSIONARY) != 0) ? match : !match) 
                    {
                        if (k >= min)
                            i--;

                        return k >= min;
                    }
                    break;

                case ANCHOR_START:
                    return i == 0 || ((flags & MULTILINE) != 0 && (text[i - 1] == '\r' || text[i - 1] == '\n' || text[i - 1] == '\f'));

                case ANCHOR_END:
                    return i >= text.length || ((flags & MULTILINE) != 0 && (text[i + 1] == '\r' || text[i + 1] == '\n' || text[i + 1] == '\f' || text[i + 1] == '\0'));

                case GROUP:
                    uint curri = i - 1;
                    foreach (j; 0..elements.length) 
                    {
                        if (!elements[j].fulfilled(elements, cast(uint)j + 1, flags, text, (elements[j].min != 0 ? i + 1 < text.length ? ++i : i : i))) 
                        {
                            if (k >= min)
                                i = curri;

                            return k >= min;
                        }
                    }

                    break;

                case ANY:
                    if ((flags & SINGLELINE) == 0 && (text[i] == '\r' || text[i] == '\n' || text[i] == '\f')) 
                    {
                        if (k >= min)
                            i--;
                        
                        return k >= min;
                    }
                    break;

                case REFERENCE:
                    if (!elements[0].fulfilled(glob, next, flags, text, i)) 
                    {
                        if (k >= min)
                            i--;
                        
                        return k >= min;
                    }

                    i += elements[0].min;
                    break;

                case PUSHFW:
                    i += min;
                    return true;

                case PUSHBW:
                    i -= min;
                    return true;

                default:
                    return false;
            }
        }
        return true;
    }
}

private string[string] lookups;

static this()
{
    lookups["\\w"] = expand("a-zA-Z0-9_", lookups);
    lookups["\\d"] = expand("0-9", lookups);
    lookups["\\s"] = expand(" \t\r\n\f", lookups);
    lookups["\\h"] = expand(" \t", lookups);
    lookups["\\t"] = expand("\t", lookups);
    lookups["\\r"] = expand("\r", lookups);
    lookups["\\n"] = expand("\n", lookups);
    lookups["\\f"] = expand("\f", lookups);
    lookups["\\v"] = expand("\v", lookups);
    lookups["\\b"] = expand("\b", lookups);
    lookups["\\a"] = expand("\a", lookups);
    lookups["\\0"] = expand("\0", lookups);
}

pure string expand(string str, ref string[string] lookups)
{
    if (str in lookups)
        return lookups[str];

    string ret;
    int i = 0;
    while (i < str.length)
    {
        if (str[i] == '\\' && i + 1 < str.length && str[i..(i + 2)] in lookups)
        {
            ret ~= lookups[str[i..(i += 2)]];
        }
        else if (i + 2 < str.length && str[i + 1] == '-')
        {
            char start = str[i];
            char end = str[i + 2];
            foreach (c; start..(end + 1))
                ret ~= c;
            i += 3;
        }
        else
        {
            ret ~= str[i++];
        }
    }
    lookups[str] = ret;
    return ret;
}

/**
    Determines if an Element may be quantified based on its modifiers.

    Params:
    - `element`: The Element to be checked for quantification.

    Returns:
        A boolean indicating whether the Element can be quantified.

    Example:
        ```d
        Element myElement;
        bool canQuantify = myElement.mayQuantify;
        ```
*/
pragma(inline, true);
pure @nogc bool mayQuantify(Element element)
{
    return (element.modifiers & QUANTIFIED) == 0;
}

/**
    Determines if an Element should be quantified based on its token type.

    Params:
    - `element`: The Element to be checked for quantification.

    Returns:
        A boolean indicating whether the Element should be quantified.

    Example:
        ```d
        Element myElement;
        bool shouldQuantify = myElement.shouldQuantify;
        ```
*/
pragma(inline, true);
pure @nogc bool shouldQuantify(Element element)
{
    return element.token != ANCHOR_START && element.token != ANCHOR_END && element.token != PUSHFW && element.token != PUSHBW;
}

/**
    Retrieves the substring enclosed by specified opening and closing characters in a string.

    Params:
    - `pattern`: The string containing the substring.
    - `start`: The starting index of the substring.
    - `opener`: The opening character delimiting the substring.
    - `closer`: The closing character delimiting the substring.

    Returns:
        A string representing the substring enclosed by `opener` and `closer`.

    Remarks:
        Will account for additional openers and closers to get the correct substring.

    Example:
        ```d
        string inputPattern = "Some string (with enclosed text)";
        string argument = inputPattern.getArgument(10, '(', ')');
        ```
*/
pure @nogc string getArgument(string pattern, int start, char opener, char closer)
{
    int openers = 1;
    foreach (i; (start + 1)..pattern.length)
    {
        if (pattern[i] == opener)
            openers++;
        else if (pattern[i] == closer)
            openers--;
        
        if (openers == 0)
            return pattern[(start + 1)..i];
    }
    return pattern[(start + 1)..pattern.length];
}

/**
    Builds an array of regex elements based on the provided pattern using a specified cache function.

    This function is realistically pure but cannot be marked as pure due to its invocation of 
    an arbitrary function (`fn`).

    Params:
        `fn`: The function used for character mapping.
        `pattern`: The regex pattern to parse.

    Returns:
        An array of `Element` objects built from the given pattern.

    Example Usage:
        ```
        auto elements = "a+b*c?".build!expand();
        ```
*/
// TODO: \b \B \R groups lookahead lookbehind
pragma(inline, true);
private pure Element[] build(string pattern, string[string] lookups)
{
    Element[] elements;
    for (int i; i < pattern.length; i++)
    {
        Element element;
        char c = pattern[i];
        switch (c)
        {
            case '+':
                if (!elements[$-1].shouldQuantify)
                    continue;

                if (elements[$-1].mayQuantify)
                {
                    elements[$-1].min = 1;
                    elements[$-1].max = uint.max;
                    elements[$-1].modifiers |= QUANTIFIED;
                }
                else
                {
                    elements[$-1].modifiers |= GREEDY;
                }
                break;

            case '*':
                if (!elements[$-1].shouldQuantify)
                    continue;

                if (!elements[$-1].mayQuantify)
                    continue;

                elements[$-1].min = 0;
                elements[$-1].max = uint.max;
                elements[$-1].modifiers |= QUANTIFIED;
                break;

            case '?':
                if (!elements[$-1].shouldQuantify)
                    continue;

                if (elements[$-1].mayQuantify)
                {
                    elements[$-1].min = 0;
                    elements[$-1].max = 1;
                    elements[$-1].modifiers |= QUANTIFIED;
                }
                else 
                {
                    elements[$-1].modifiers |= LAZY;
                }
                break;

            case '{':
                if (!elements[$-1].shouldQuantify)
                    continue;

                if (!elements[$-1].mayQuantify)
                    continue;

                string arg = pattern.getArgument(i, '{', '}');
                string[] args = arg.split("..");
                if (args.length == 1)
                {
                    elements[$-1].min = args[0].to!uint;
                    elements[$-1].max = args[0].to!uint;
                }
                else if (args.length == 2)
                {
                    elements[$-1].min = args[0].to!uint;
                    elements[$-1].max = args[1].to!uint;
                }
                i += arg.length + 1;
                elements[$-1].modifiers |= QUANTIFIED;
                break;

            case '|':
                if (i + 2 < pattern.length && pattern[i..(i + 3)] == "|->")
                {
                    element.token = PUSHFW;
                    element.min = 1;
                    i += 2;
                    break;
                }
                elements[$-1].modifiers |= ALTERNATE;
                break;

            case '.':
                element.token = ANY;
                element.min = 1;
                element.max = 1;
                break;

            case '[':
                if (i + 1 < pattern.length && pattern[i + 1] == '^')
                {
                    element.modifiers |= EXCLUSIONARY;
                    i++;
                }

                element.token = CHARACTERS;
                element.str = pattern.getArgument(i, '[', ']').expand(lookups);
                element.min = 1;
                element.max = 1;

                i += pattern.getArgument(i, '[', ']').length + 1;
                break;

            case '^':
                element.token = ANCHOR_START;
                break;

            case '%':
                if (i + 1 < pattern.length && pattern[i + 1].isDigit)
                {
                    uint id = 0;
                    while (i + 1 < pattern.length && pattern[i + 1].isDigit)
                        id = id * 10 + (pattern[++i] - '0');

                    if (id < elements.length)
                    {
                        element.token = REFERENCE;
                        element.elements = [ elements[id] ];
                    }
                    break;
                }
                break;

            case '$':
                if (i + 1 < pattern.length && pattern[i + 1].isDigit)
                {
                    uint id = 0;
                    while (i + 1 < pattern.length && pattern[i + 1].isDigit)
                        id = id * 10 + (pattern[++i] - '0');

                    for (uint ii = 0, visits = 0; ii < elements.length; ++ii)
                    {
                        if (elements[ii].token == GROUP && visits++ == id)
                        {
                            element.token = REFERENCE;
                            element.elements = [ elements[ii] ];
                            break;
                        }
                    }
                }
                element.token = ANCHOR_END;
                break;

            case '<':
                if (i + 2 < pattern.length && pattern[i + 1] == '-' && pattern[i + 2] == '|')
                {
                    element.token = PUSHBW;
                    element.min = 1;
                    i += 2;
                    break;
                }
                else if (i + 2 < pattern.length && pattern[i + 1] == '-' && pattern[i + 2].isDigit)
                {
                    i++;
                    uint len = 0;
                    while (i + 1 < pattern.length && pattern[i + 1].isDigit)
                        len = len * 10 + (pattern[++i] - '0');

                    element.token = PUSHBW;
                    element.min = len;
                    break;
                }
                break;

            case '(':
                string arg = pattern.getArgument(i, '(', ')');
                element.token = GROUP;
                element.elements = arg.build(lookups);
                i += arg.length + 1;
                break;

            default:
                if (c.isDigit)
                {
                    uint ci = i;
                    uint len = c - '0';
                    while (i + 1 < pattern.length && pattern[i + 1].isDigit)
                        len = len * 10 + (pattern[++i] - '0');
                    
                    if (i + 2 < pattern.length && pattern[(i + 1)..(i + 3)] == "->")
                    {
                        element.token = PUSHFW;
                        element.min = len;
                        i += 2;
                        break;
                    }
                    i = ci;
                }

                element.token = CHARACTERS;
                // Will not be adding support for \gn
                // Expected to use $n
                if (c == '\\' && i + 1 < pattern.length)
                {
                    // Reset (local)
                    if (pattern[i..(i + 2)] == r"\K")
                    {
                        i++;
                        element.token = RESET;
                        if (i + 1 < pattern.length && pattern[i + 1].isDigit)
                        {
                            uint id = 0;
                            while (i + 1 < pattern.length && pattern[i + 1].isDigit)
                                id = id * 10 + (pattern[++i] - '0');

                            for (uint ii = 0, visits = 0; ii < elements.length; ++ii)
                            {
                                if (elements[ii].token == GROUP && visits++ == id)
                                {
                                    element.token = REFERENCE;
                                    element.elements = [ elements[ii] ];
                                    break;
                                }
                            }
                        }
                        break;
                    }
                    // Escaped escape
                    else if (pattern[i..(i + 2)] == r"\\")
                    {
                        element.str = c.to!string;
                        element.min = 1;
                        element.max = 1;
                        i++;
                        break;
                    }
                    else if (pattern[i..(i + 2)] == r"\x" && i + 3 < pattern.length)
                    {
                        string hex = pattern[i + 2 .. i + 4];
                        element.str = (cast(char)hex.to!ubyte(16)).to!string;
                        element.min = 1;
                        element.max = 1;
                        i += 3;
                        break;
                    }
                    // Any escape
                    else
                    {
                        string arg = pattern[i..(++i + 1)];
                        switch (arg)
                        {
                            case r"\W", r"\D", r"\S", r"\H", r"\V":
                                element.str = arg.toLower.expand(lookups);
                                element.min = 1;
                                element.max = 1;
                                element.modifiers |= EXCLUSIONARY;
                                break;

                            default:
                                element.str = arg.expand(lookups);
                                element.min = 1;
                                element.max = 1;
                        }
                    }
                }
                else
                {
                    element.str = c.to!string;
                    element.min = 1;
                    element.max = 1;
                }
                break;
        }
        if (element.token != BAD)
            elements ~= element;
    }
    return elements;
}

/++
    Matches the elements against the text and returns any match.

    Params:
    - `elements`: An array of elements defining the pattern to match against the text.
    - `table`: A character array used for matching specific characters.
    - `flags`: An unsigned byte containing flags for various matching conditions.
    - `text`: The string in which the pattern is being searched.

    Returns:
        Matched string, or null.

    Remarks:
        This function iterates through the provided elements, attempting to match them against the given text.
        It constructs a string based on the fulfilled conditions of the elements.

    Example:
        ```d
        Element[] patternElements = [/*...*/];
        char[] matchingTable = "abc";
        ubyte matchingFlags = 0;
        string inputText = "Example text to match";
        string result = mmatch(patternElements, matchingTable, matchingFlags, inputText);
        ```
+/
pragma(inline, true);
private static pure string mmatchFirst(Element[] elements, ubyte flags, string text)
{
    string match;
    uint i;
    uint ii;

    while (ii < elements.length)
    {
        Element element = elements[ii];
        
        if (element.token != ANCHOR_END && i >= text.length)
            return null;
        
        uint iv = i;
        if (element.fulfilled(elements, ii + 1, flags, text, i))
        {
            match ~= text[iv..(element.min != 0 ? i + 1 < text.length ? ++i : i : i)];
            ii++;
        }
        else if (element.token == RESET)
        {
            match = null;
        }
        else if ((element.modifiers & ALTERNATE) != 0)
        {
            ii++;
            
            if (element.fulfilled(elements, ii + 1, flags, text, i))
            {
                match ~= text[iv..(element.min != 0 ? i + 1 < text.length ? ++i : i : i)];
                ii++;
            }
        }
        else
        {
            if (!elements[0].fulfilled(elements, ii + 1, flags, text, i))
                i++;
            
            match = null;
            ii = 0;
        }
    }
    
    return match;
}

/// ditto
pragma(inline, true);
private static pure string[] mmatch(Element[] elements, ubyte flags, string text)
{
    string[] matches;
    uint i;
    uint ii;
    uint iii;
    
    while (i < text.length)
    {
        matches ~= null;
        while (ii < elements.length)
        {
            Element element = elements[ii];
            
            if (element.token != ANCHOR_END && i >= text.length + 1)
                return matches[0..$-1];
            
            uint iv = i;
            if (element.fulfilled(elements, ii + 1, flags, text, i))
            {
                matches[iii] ~= text[iv..(element.min != 0 ? i + 1 < text.length ? ++i : i : i)];
                ii++;
            }
            else if (element.token == RESET)
            {
                matches[iii] = null;
            }
            else if ((element.modifiers & ALTERNATE) != 0)
            {
                ii++;
                
                if (element.fulfilled(elements, ii + 1, flags, text, i))
                {
                    matches[iii] ~= text[iv..(element.min != 0 ? i + 1 < text.length ? ++i : i : i)];
                    ii++;
                }
            }
            else
            {
                if (!elements[0].fulfilled(elements, ii + 1, flags, text, i))
                    i++;
                
                matches[iii] = null;
                ii = 0;
            }
        }
        ii = 0;
        iii++;
    }
    return matches;
}

/** Provides interface for compile-time regex.
   
    Not to be confused with `Regex`, which is used for runtime regex generated at runtime.

    Remarks:
        Does not benefit from caching, so use the `Regex` class instead when possible.

    Examples:
        ```d
        regex!(r"\s", GLOBAL).match!("hey, I just met you, and this is crazy but here's my number, so call me, maybe");
        ```
        ```d
        Regex re = regex!(r"\s", GLOBAL).ctor();
        ```
*/
public template regex(string PATTERN, ubyte FLAGS)
{
public:
    Regex ctor()
    {
        return new Regex(PATTERN, FLAGS);
    }

    pure string matchFirst(string TEXT)()
    {
        string[string] lookups;
        lookups["\\w"] = expand("a-zA-Z0-9_", lookups);
        lookups["\\d"] = expand("0-9", lookups);
        lookups["\\s"] = expand(" \t\r\n\f", lookups);
        lookups["\\h"] = expand(" \t", lookups);
        lookups["\\t"] = expand("\t", lookups);
        lookups["\\r"] = expand("\r", lookups);
        lookups["\\n"] = expand("\n", lookups);
        lookups["\\f"] = expand("\f", lookups);
        lookups["\\v"] = expand("\v", lookups);
        lookups["\\b"] = expand("\b", lookups);
        lookups["\\a"] = expand("\a", lookups);
        lookups["\\0"] = expand("\0", lookups);

        //return null;
        return mmatchFirst(PATTERN.build(lookups), FLAGS, TEXT);
    }

    pure string[] match(string TEXT)()
    {
        string[string] lookups;
        lookups["\\w"] = expand("a-zA-Z0-9_", lookups);
        lookups["\\d"] = expand("0-9", lookups);
        lookups["\\s"] = expand(" \t\r\n\f", lookups);
        lookups["\\h"] = expand(" \t", lookups);
        lookups["\\t"] = expand("\t", lookups);
        lookups["\\r"] = expand("\r", lookups);
        lookups["\\n"] = expand("\n", lookups);
        lookups["\\f"] = expand("\f", lookups);
        lookups["\\v"] = expand("\v", lookups);
        lookups["\\b"] = expand("\b", lookups);
        lookups["\\a"] = expand("\a", lookups);
        lookups["\\0"] = expand("\0", lookups);

        //return null;
        return mmatch(PATTERN.build(lookups), FLAGS, TEXT);
    }
}

/** Provides interface for runtime regex.
   
    Not to be confused with `regex`, which is used for building or executing comptime regex.

    Remarks:
        May be built at compile time with `regex!(string PATTERN, ubyte FLAGS).ctor()`.
    
    Examples:
        ```
        Regex re = new Regex(r"[ab]", GLOBAL);
        writeln(rg.match("hey, I just met you, and this is crazy but here's my number, so call me, maybe"));
        ```
*/
public class Regex
{
private:
    Element[] elements;
    ubyte flags;

public:
    
    this(string pattern, ubyte flags)
    {
        this.elements = pattern.build(lookups);
        this.flags = flags;
    }

    string matchFirst(string text)
    {
        return mmatchFirst(elements, flags, text);
    }

    string[] match(string text)
    {
        return mmatch(elements, flags, text);
    }
} 