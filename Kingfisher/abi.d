module abi;

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
                cmp AX, 2;   // Compare type with 2
        	    jne pq; // Pack
        	    mov R10, "~from~"; // Move ref pointer to R10
        	    mov "~to~", R10; // Move ref pointer to 'to'
        	    jmp exit; // Avoid packing
            pq:
                lea R10, ["~from~"]; // Load the address of the data
        	    mov "~to~", R10; // Move address to 'to'
            exit:;
            }";
        }
        version (X86)
        {
            const string pack =
            "asm
            {
                mov AX, "~(behavior + 48)~"; // Move type to AX and adjust for integer
                cmp AX, 2;   // Compare type with 2
        	    jne pq; // Pack
        	    mov EAX, "~from~"; // Move ref pointer to EAX
        	    mov "~to~", EAX; // Move ref pointer to 'to'
        	    jmp exit; // Avoid packing
            pq:
                lea EAX, ["~from~"]; // Load the address of the data
        	    mov "~to~", EAX; // Move address to 'to'
            exit:;
            }";
        }   
    }
}
else
{
    // SystemV
}