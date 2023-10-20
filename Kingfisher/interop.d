module interop;

import std.stdio;

// TODO: SystemV Support

/*template pack(string to, string from, CCVType type)
{
    version (X86_64)
    {
        const string pack =
        "asm{
            mov AX, "~(type + 48)~"; // Move type to AX and adjust for integer
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
        "asm{
            mov AX, "~(cls + 48)~"; // Move type to AX and adjust for integer
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

template Unpack(string to, string from, CCVClassification cls)
{
    const string Unpack = 
        "asm{
            cmp [R9], 2;   // Compare classification with 2
            je reft;      // If it's zero, jump to reft (ref argument)
            mov "~to~", "~from~"; // Unpack (integer or sse) data
            jmp exit;
        reft:
            mov "~to~", ["~from~"]; // Unpack reference
        exit:;
        }";
}

template UnpackArg(string to, int index, CCVClassification cls)
{
    string ParseUnpack()
    {
        // Ideally no idiot would ever make the index be negative
        // but, alas, for we do not live in a perfect world.
        if (index < 0)
            return "";

        if (index == 0)
        {
            return Unpack!(MSABIClassification.SSE 
                ? "RCX"
                : "XMM0");
        }
        else if (index == 1)
        {
            return Unpack!(MSABIClassification.SSE 
                ? "RDX"
                : "XMM1");
        }
        else if (index == 2)
        {
            return Unpack!(MSABIClassification.SSE 
                ? "R8"
                : "XMM2");
        }
        else if (index == 3)
        {
            return Unpack!(MSABIClassification.SSE 
                ? "R9"
                : "XMM3");
        }
        // The index is not one which is stored in registers
        else
        {
            return "asm{
                cmp [R8], 2;   // Compare classification with 2
                je reft;      // If it's not zero, jump to reft (ref argument)
                mov "~to~", RSP + 32 + (index * 8); // Unpack (integer or sse) data
                jmp exit;
            reft:
                mov "~to~", [RSP + 32 + (index * 8)];; // Unpack reference
            exit:
            }";
        }
    }

    const string UnpackArg = ParseUnpack();
}*/

// Used to call a C# method that returns an integer sized value type.
extern (C) export ulong InvokeVTEx(ptrdiff_t pfn, void** args, short* series)
{
    asm @nogc
    {
        naked;
        even;

        mov R12, RCX; // pfn: Move the function pointer to R12
        mov R13, RDX; // args: Move the args pointer to R13
        mov R14, R8;  // series: Move the series pointer to R14

        // Calculate the space needed on the stack for arguments and local variables
        movsx RDI, [R14 + 0]; // Load series[0] (number of arguments)
        sub RDI, 4;           // Subtract 4 from the argument count
        imul RDI, RDI, 16;    // Multiply the result by 16 (each argument takes 16 bytes)
        add RDI, 40;          // Add 40 to account for other local variables
        sub RSP, RDI;         // Adjust the stack pointer to allocate space

        // Check if the first pointer in args is a valid instance pointer.
        cmp [R13 + 0], 0;  // Compare the first pointer in args with 0
        jnz arg0_inst;     // Jump to arg0_inst if it's not zero

        /************************************************************************************/
        /*                      UNINSTANTIATED METHOD PARAMETER SETUP                       */
        /************************************************************************************/

    arg0_uninst:
        cmp [R14 + 0], 0;   // Compare series[0] with 0
        je invoke;          // If it's zero, jump to invoke (method call)
        mov RCX, [R13 + 8]; // Load the first argument from args to RCX
        cmp [R14 + 2], 0;   // Compare series[2] with 0
        je vt0_uninst;      // If it's zero, jump to vt0_uninst (value type argument)
        cmp [R14 + 2], 1;   // Compare series[2] with 1
        je fp0_uninst;      // If it's one, jump to fp0_uninst (floating-point argument)
        jmp arg1_uninst;    // Otherwise, jump to arg1_uninst (next argument)
    vt0_uninst:
        mov RCX, [RCX];       // Load RDI (offset) to RCX for value type argument
        jmp arg1_uninst;    // Jump to arg1_uninst (next argument)
    fp0_uninst:
        movss XMM0, [RCX];  // Load a single-precision float argument to XMM0

    arg1_uninst:
        cmp [R14 + 0], 1;    // Compare series[0] with 1
        je invoke;           // If it's zero, jump to invoke (method call)
        mov RDX, [R13 + 16]; // Load the first argument from args to RCX
        cmp [R14 + 4], 0;    // Compare series[2] with 0
        je vt1_uninst;       // If it's zero, jump to vt0_uninst (value type argument)
        cmp [R14 + 4], 1;    // Compare series[2] with 1
        je fp1_uninst;       // If it's one, jump to fp0_uninst (floating-point argument)
        jmp arg2_uninst;     // Otherwise, jump to arg1_uninst (next argument)
    vt1_uninst:
        mov RDX, [RDX];      // Load RDI (offset) to RCX for value type argument
        jmp arg2_uninst;     // Jump to arg1_uninst (next argument)
    fp1_uninst:
        movss XMM1, [RDX];   // Load a single-precision float argument to XMM1

    arg2_uninst:
        cmp [R14 + 0], 2;
        je invoke;
        mov R8, [R13 + 24];
        cmp [R14 + 6], 0;
        je vt2_uninst;
        cmp [R14 + 6], 1;
        je fp2_uninst;
        jmp arg3_uninst;
    vt2_uninst:
        mov R8, [R8];
        jmp arg3_uninst;
    fp2_uninst:
        movss XMM2, [R8];

    arg3_uninst:
        cmp [R14 + 0], 3;
        je invoke;
        mov R9, [R13 + 32];
        cmp [R14 + 8], 0;
        je vt3_uninst;
        cmp [R14 + 8], 1;
        je fp3_uninst;
        jmp arg4;
    vt3_uninst:
        mov R9, [R9];
        jmp arg4;
    fp3_uninst:
        movss XMM3, [R9];

    arg4:
        cmp [R14 + 0], 4;
        je invoke;
        mov R10, [R13 + 40];
        cmp [R14 + 10], 0;
        je vt4;
        cmp [R14 + 10], 1;
        je fp4;
        mov [RSP + 32], R10;
        jmp arg5;
    vt4:
        mov R10, [R10];
        mov [RSP + 32], R10;
        jmp arg5;
    fp4:
        movss XMM10, [R10];
        movss [RSP + 32], XMM10;

    arg5:
        cmp [R14 + 0], 5;
        je invoke;
        mov R10, [R13 + 48];
        cmp [R14 + 12], 0;
        je vt5;
        cmp [R14 + 12], 1;
        je fp5;
        mov [RSP + 40], R10;
        jmp arg6;
    vt5:
        mov R10, [R10];
        mov [RSP + 40], R10;
        jmp arg6;
    fp5:
        movss XMM10, [R10];
        movss [RSP + 40], XMM10;

    arg6:
        cmp [R14 + 0], 6;
        je invoke;
        mov R10, [R13 + 56];
        cmp [R14 + 14], 0;
        je vt6;
        cmp [R14 + 14], 1;
        je fp6;
        mov [RSP + 48], R10;
        jmp arg7;
    vt6:
        mov R10, [R10];
        mov [RSP + 48], R10;
        jmp arg7;
    fp6:
        movss XMM10, [R10];
        movss [RSP + 48], XMM10;

    arg7:
        cmp [R14 + 0], 7;
        je invoke;
        mov R10, [R13 + 64];
        cmp [R14 + 16], 0;
        je vt7;
        cmp [R14 + 16], 1;
        je fp7;
        mov [RSP + 56], R10;
        jmp arg8;
    vt7:
        mov R10, [R10];
        mov [RSP + 56], R10;
        jmp arg8;
    fp7:
        movss XMM10, [R10];
        movss [RSP + 56], XMM10;

    arg8:
        cmp [R14 + 0], 8;
        je invoke;
        mov R10, [R13 + 72];
        cmp [R14 + 18], 0;
        je vt8;
        cmp [R14 + 18], 1;
        je fp8;
        mov [RSP + 64], R10;
        jmp arg9;
    vt8:
        mov R10, [R10];
        mov [RSP + 64], R10;
        jmp arg9;
    fp8:
        movss XMM10, [R10];
        movss [RSP + 64], XMM10;

    arg9:
        cmp [R14 + 0], 9;
        je invoke;
        mov R10, [R13 + 80];
        cmp [R14 + 20], 0;
        je vt9;
        cmp [R14 + 20], 1;
        je fp9;
        mov [RSP + 72], R10;
        jmp arg10;
    vt9:
        mov R10, [R10];
        mov [RSP + 72], R10;
        jmp arg10;
    fp9:
        movss XMM10, [R10];
        movss [RSP + 72], XMM10;

    arg10:
        cmp [R14 + 0], 10;
        je invoke;
        mov R10, [R13 + 88];
        cmp [R14 + 22], 0;
        je vt10;
        cmp [R14 + 22], 1;
        je fp10;
        mov [RSP + 72], R10;
        jmp invoke;
    vt10:
        mov R10, [R10];
        mov [RSP + 80], R10;
        jmp invoke;
    fp10:
        movss XMM10, [R10];
        movss [RSP + 80], XMM10;
        jmp invoke;

        /************************************************************************************/
        /*                        INSTANTIATED METHOD PARAMETER SETUP                       */
        /************************************************************************************/

    arg0_inst:
        // Move RDX (pObj) to RCX to be the 'this' parameter in an instance method
        // We do not want to do this with statics, despite the fact that they don't need an instance
        mov RCX, [R13 + 0];

    arg1_inst:
        cmp [R14 + 0], 0; // Compare series[0] with 0
        je invoke;        // If it's zero, jump to invoke (method call)
        mov RDX, [R13 + 8]; // Load the first argument from args to RDX
        cmp [R14 + 2], 0;  // Compare series[2] with 0
        je vt1_inst;       // If it's zero, jump to vt1_inst (value type argument)
        cmp [R14 + 2], 1;  // Compare series[2] with 1
        je fp1_inst;       // If it's one, jump to fp1_inst (floating-point argument)
        jmp arg2_inst;     // Otherwise, jump to arg2_inst (next argument)
    vt1_inst:
        mov RDX, [RDX]; // Load the value type argument from the reference
        jmp arg2_inst;
    fp1_inst:
        movss XMM1, [RDX]; // Load a single-precision float argument to XMM1

    arg2_inst:
        cmp [R14 + 0], 1; // Compare series[0] with 1
        je invoke;        // If it's one, jump to invoke (method call)
        mov R8, [R13 + 16]; // Load the second argument from args to R8
        cmp [R14 + 4], 0;  // Compare series[4] with 0
        je vt2_inst;       // If it's zero, jump to vt2_inst (value type argument)
        cmp [R14 + 4], 1;  // Compare series[4] with 1
        je fp2_inst;       // If it's one, jump to fp2_inst (floating-point argument)
        jmp arg3_inst;     // Otherwise, jump to arg3_inst (next argument)
    vt2_inst:
        mov R8, [R8]; // Load the value type argument from the reference
        jmp arg3_inst;
    fp2_inst:
        movss XMM2, [R8]; // Load a single-precision float argument to XMM2

    arg3_inst:
        cmp [R14 + 0], 2;
        je invoke;
        mov R9, [R13 + 24];
        cmp [R14 + 6], 0;
        je vt3_inst;
        cmp [R14 + 6], 1;
        je fp3_inst;
        jmp arg4;
    vt3_inst:
        mov R9, [R9];
        jmp arg4;
    fp3_inst:
        movss XMM3, [R9];
        jmp arg4;

        /************************************************************************************/
        /*                                 INVOKE METHOD                                    */
        /************************************************************************************/

    invoke:
        call R12;     // Call the C# method using the function pointer in R12
        add RSP, RDI; // Restore the stack pointer (remove allocated space)
        ret;          // Return from the function
    }
}

// Used to call a C# method that does not return an integer sized value type.
extern (C) export pure @nogc void* InvokeRFEx(ptrdiff_t pfn, void* pobj)
{
    asm pure @nogc
    {
        naked;
        even;

        push RSI;     // Push source index onto the stack
        mov R12, RCX; // pfn: Move the function pointer to R12
        mov R13, RDX; // args: Move the args pointer to R13
        mov R14, R8;  // series: Move the series pointer to R14

        // Calculate the space needed on the stack for arguments and local variables
        movsx RDI, [R14 + 0]; // Load series[0] (number of arguments)
        sub RDI, 4;           // Subtract 4 from the argument count
        imul RDI, RDI, 16;    // Multiply the result by 16 (each argument takes 16 bytes)
        add RDI, 40;          // Add 40 to account for other local variables
        sub RSP, RDI;         // Adjust the stack pointer to allocate space

        // Check if the first pointer in args is a valid instance pointer.
        cmp [R13 + 0], 0;  // Compare the first pointer in args with 0
        jnz arg0_inst;     // Jump to arg0_inst if it's not zero

        /************************************************************************************/
        /*                      UNINSTANTIATED METHOD PARAMETER SETUP                       */
        /************************************************************************************/

    arg0_uninst:
        cmp [R14 + 0], 0;   // Compare series[0] with 0
        je invoke;          // If it's zero, jump to invoke (method call)
        mov RCX, [R13 + 8]; // Load the first argument from args to RCX
        cmp [R14 + 2], 0;   // Compare series[2] with 0
        je vt0_uninst;      // If it's zero, jump to vt0_uninst (value type argument)
        cmp [R14 + 2], 1;   // Compare series[2] with 1
        je fp0_uninst;      // If it's one, jump to fp0_uninst (floating-point argument)
        jmp arg1_uninst;    // Otherwise, jump to arg1_uninst (next argument)
    vt0_uninst:
        mov RCX, RDI;       // Load RDI (offset) to RCX for value type argument
        jmp arg1_uninst;    // Jump to arg1_uninst (next argument)
    fp0_uninst:
        movss XMM0, [RCX];  // Load a single-precision float argument to XMM0

    arg1_uninst:
        cmp [R14 + 0], 1;    // Compare series[0] with 1
        je invoke;           // If it's zero, jump to invoke (method call)
        mov RDX, [R13 + 16]; // Load the first argument from args to RCX
        cmp [R14 + 4], 0;    // Compare series[2] with 0
        je vt1_uninst;       // If it's zero, jump to vt0_uninst (value type argument)
        cmp [R14 + 4], 1;    // Compare series[2] with 1
        je fp1_uninst;       // If it's one, jump to fp0_uninst (floating-point argument)
        jmp arg2_uninst;     // Otherwise, jump to arg1_uninst (next argument)
    vt1_uninst:
        mov RDX, [RDX];      // Load RDI (offset) to RCX for value type argument
        jmp arg2_uninst;     // Jump to arg1_uninst (next argument)
    fp1_uninst:
        movss XMM1, [RDX];   // Load a single-precision float argument to XMM1

    arg2_uninst:
        cmp [R14 + 0], 2;
        je invoke;
        mov R8, [R13 + 24];
        cmp [R14 + 6], 0;
        je vt2_uninst;
        cmp [R14 + 6], 1;
        je fp2_uninst;
        jmp arg3_uninst;
    vt2_uninst:
        mov R8, [R8];
        jmp arg3_uninst;
    fp2_uninst:
        movss XMM2, [R8];

    arg3_uninst:
        cmp [R14 + 0], 3;
        je invoke;
        mov R9, [R13 + 32];
        cmp [R14 + 8], 0;
        je vt3_uninst;
        cmp [R14 + 8], 1;
        je fp3_uninst;
        jmp arg4;
    vt3_uninst:
        mov R9, [R9];
        jmp arg4;
    fp3_uninst:
        movss XMM3, [R9];

    arg4:
        cmp [R14 + 0], 4;
        je invoke;
        mov R10, [R13 + 40];
        cmp [R14 + 10], 0;
        je vt4;
        cmp [R14 + 10], 1;
        je fp4;
        mov [RSP + 32], R10;
        jmp arg5;
    vt4:
        mov R10, [R10];
        mov [RSP + 32], R10;
        jmp arg5;
    fp4:
        movss XMM10, [R10];
        movss [RSP + 32], XMM10;

    arg5:
        cmp [R14 + 0], 5;
        je invoke;
        mov R10, [R13 + 48];
        cmp [R14 + 12], 0;
        je vt5;
        cmp [R14 + 12], 1;
        je fp5;
        mov [RSP + 40], R10;
        jmp arg6;
    vt5:
        mov R10, [R10];
        mov [RSP + 40], R10;
        jmp arg6;
    fp5:
        movss XMM10, [R10];
        movss [RSP + 40], XMM10;

    arg6:
        cmp [R14 + 0], 6;
        je invoke;
        mov R10, [R13 + 56];
        cmp [R14 + 14], 0;
        je vt6;
        cmp [R14 + 14], 1;
        je fp6;
        mov [RSP + 48], R10;
        jmp arg7;
    vt6:
        mov R10, [R10];
        mov [RSP + 48], R10;
        jmp arg7;
    fp6:
        movss XMM10, [R10];
        movss [RSP + 48], XMM10;

    arg7:
        cmp [R14 + 0], 7;
        je invoke;
        mov R10, [R13 + 64];
        cmp [R14 + 16], 0;
        je vt7;
        cmp [R14 + 16], 1;
        je fp7;
        mov [RSP + 56], R10;
        jmp arg8;
    vt7:
        mov R10, [R10];
        mov [RSP + 56], R10;
        jmp arg8;
    fp7:
        movss XMM10, [R10];
        movss [RSP + 56], XMM10;

    arg8:
        cmp [R14 + 0], 8;
        je invoke;
        mov R10, [R13 + 72];
        cmp [R14 + 18], 0;
        je vt8;
        cmp [R14 + 18], 1;
        je fp8;
        mov [RSP + 64], R10;
        jmp arg9;
    vt8:
        mov R10, [R10];
        mov [RSP + 64], R10;
        jmp arg9;
    fp8:
        movss XMM10, [R10];
        movss [RSP + 64], XMM10;

    arg9:
        cmp [R14 + 0], 9;
        je invoke;
        mov R10, [R13 + 80];
        cmp [R14 + 20], 0;
        je vt9;
        cmp [R14 + 20], 1;
        je fp9;
        mov [RSP + 72], R10;
        jmp arg10;
    vt9:
        mov R10, [R10];
        mov [RSP + 72], R10;
        jmp arg10;
    fp9:
        movss XMM10, [R10];
        movss [RSP + 72], XMM10;

    arg10:
        cmp [R14 + 0], 10;
        je invoke;
        mov R10, [R13 + 88];
        cmp [R14 + 22], 0;
        je vt10;
        cmp [R14 + 22], 1;
        je fp10;
        mov [RSP + 72], R10;
        jmp invoke;
    vt10:
        mov R10, [R10];
        mov [RSP + 80], R10;
        jmp invoke;
    fp10:
        movss XMM10, [R10];
        movss [RSP + 80], XMM10;
        jmp invoke;

        /************************************************************************************/
        /*                        INSTANTIATED METHOD PARAMETER SETUP                       */
        /************************************************************************************/

    arg0_inst:
        // Move RDX (pObj) to RCX to be the 'this' parameter in an instance method
        // We do not want to do this with statics, despite the fact that they don't need an instance
        mov RCX, [R13 + 0];

    arg1_inst:
        cmp [R14 + 0], 0; // Compare series[0] with 0
        je invoke;        // If it's zero, jump to invoke (method call)
        mov RDX, [R13 + 8]; // Load the first argument from args to RDX
        cmp [R14 + 2], 0;  // Compare series[2] with 0
        je vt1_inst;       // If it's zero, jump to vt1_inst (value type argument)
        cmp [R14 + 2], 1;  // Compare series[2] with 1
        je fp1_inst;       // If it's one, jump to fp1_inst (floating-point argument)
        jmp arg2_inst;     // Otherwise, jump to arg2_inst (next argument)
    vt1_inst:
        mov RDX, [RDX]; // Load the value type argument from the reference
        jmp arg2_inst;
    fp1_inst:
        movss XMM1, [RDX]; // Load a single-precision float argument to XMM1

    arg2_inst:
        cmp [R14 + 0], 1; // Compare series[0] with 1
        je invoke;        // If it's one, jump to invoke (method call)
        mov R8, [R13 + 16]; // Load the second argument from args to R8
        cmp [R14 + 4], 0;  // Compare series[4] with 0
        je vt2_inst;       // If it's zero, jump to vt2_inst (value type argument)
        cmp [R14 + 4], 1;  // Compare series[4] with 1
        je fp2_inst;       // If it's one, jump to fp2_inst (floating-point argument)
        jmp arg3_inst;     // Otherwise, jump to arg3_inst (next argument)
    vt2_inst:
        mov R8, [R8]; // Load the value type argument from the reference
        jmp arg3_inst;
    fp2_inst:
        movss XMM2, [R8]; // Load a single-precision float argument to XMM2

    arg3_inst:
        cmp [R14 + 0], 2;
        je invoke;
        mov R9, [R13 + 24];
        cmp [R14 + 6], 0;
        je vt3_inst;
        cmp [R14 + 6], 1;
        je fp3_inst;
        jmp arg4;
    vt3_inst:
        mov R9, [R9];
        jmp arg4;
    fp3_inst:
        movss XMM3, [R9];
        jmp arg4;

        /************************************************************************************/
        /*                                 INVOKE METHOD                                    */
        /************************************************************************************/

    invoke:
        mov RCX, RSI; // Create space for reference
        call R12;     // Call the C# method using the function pointer in R12
        add RSP, RDI; // Restore the stack pointer (remove allocated space)
        pop RSI;      // Restore the source index
        ret;         // Return from the function
    }
}