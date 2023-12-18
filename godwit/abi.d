module godwit.abi;

public enum Behavior
{
    Integer,
    SSE,
    Reference
}

version(Windows)
{
    // MSABI
    template pack(string to, string from, Behavior behavior)
    {
        version (X86_64)
        {
            const string pack =
            "asm
            {
                mov AX, "~(behavior + 48)~"; // Move type to AX and adjust for integer
                cmp AX, 2;         // Compare type with 2
        	    jne pq;            // Pack if not a reference
        	    mov R10, "~from~"; // Move ref pointer to R10
        	    mov "~to~", R10;   // Move ref pointer to 'to'
        	    jmp exit;          // Avoid packing
            pq:
                lea R10, ["~from~"]; // Load the address of the data
        	    mov "~to~", R10;     // Move address to 'to'
            exit:;
            }";
        }
        version (X86)
        {
            const string pack =
            "asm
            {
                mov AX, "~(behavior + 48)~"; // Move type to AX and adjust for integer
                cmp AX, 2;         // Compare type with 2 (reference)
        	    jne pq;            // Pack if not a reference
        	    mov EAX, "~from~"; // Move ref pointer to EAX
        	    mov "~to~", EAX;   // Move ref pointer to 'to'
        	    jmp exit;          // Avoid packing
            pq:
                lea EAX, ["~from~"]; // Load the address of the data
        	    mov "~to~", EAX;     // Move address to 'to'
            exit:;
            }";
        }   
    }
    // I don't know if anything past this actually works
    template unpack(string to, string from, Behavior behavior)
    {
        const string unpack = 
            "asm
            {
            mov AX, "~(behavior + 48)~"; // Move type to AX and adjust for integer
            cmp AX, 2;   // Compare classification with 2
            je reft;      // If it's zero, jump to reft (ref argument)
            mov "~to~", "~from~"; // Unpack (integer or sse) data
            jmp exit;
            reft:
            mov "~to~", ["~from~"]; // Unpack reference
            exit:;
            }";
    }

    template unpackArg(string to, int index, Behavior behavior)
    {
        string parseUnpack()
        {
            // Ideally no idiot would ever make the index be negative
            // but, alas, for we do not live in a perfect world.
            if (index < 0)
                return "";

            if (index == 0)
            {
                return unpack!(behavior == Behavior.SSE 
                               ? "RCX"
                               : "XMM0");
            }
            else if (index == 1)
            {
                return unpack!(behavior == Behavior.SSE 
                               ? "RDX"
                               : "XMM1");
            }
            else if (index == 2)
            {
                return unpack!(behavior == Behavior.SSE 
                               ? "R8"
                               : "XMM2");
            }
            else if (index == 3)
            {
                return unpack!(behavior == Behavior.SSE 
                               ? "R9"
                               : "XMM3");
            }
            // The index is not one which is stored in registers
            else
            {
                return "asm
                {
                    mov AX, "~(behavior + 48)~"; // Move type to AX and adjust for integer
                    cmp AX, 2;   // Compare classification with 2
                    je reft;      // If it's equal, jump to reft (ref argument)
                    mov "~to~", RSP + 32 + (index * 8); // Unpack (integer or sse) data
                    jmp exit;
                    reft:
                    mov "~to~", [RSP + 32 + (index * 8)]; // Unpack reference
                    exit:;
                    }";
            }
        }

        const string unpackArg = parseUnpack();
    }
}
else
{
    // SystemV
}