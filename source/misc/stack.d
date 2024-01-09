/// Wrapper for stack arrays & interface for popping/pushing on arrays with support for LIFO and FILO
module godwit.stack;

/**
    Last In First Out

    ```d
    [] -> push(1) push(2) -> [1, 2] // Order doesn't change between LIFO vs FILO
    [1, 2] -> pop() -> [1] // Value pushed last gets popped
    ```
*/
enum LIFO;
/**
    First In Last Out

    ```d
    [] -> push(1) push(2) -> [1, 2] // Order doesn't change between LIFO vs FILO
    [1, 2] -> pop() -> [2] // Value pushed first gets popped
    ```
*/
enum FILO;

/// Wrapper class for explicitly declaring a stack.
/// 
/// Remarks:
///    Defaults to `LIFO`
public class Stack(T, O = LIFO)
{
private:
    T[] arr;
    
public:
    /** 
        Pops a value off of the stack.

        Returns:
            The value that was popped off of the stack.
    */
    pure @nogc @trusted T pop()
    {
        return arr.pop!O();
    }

    /** 
        Pushes a value onto the stack.
        
        Params:
        - `val`: The value to push onto the stack.
    */
    pure @trusted push(T val)
    {
        return arr.push(val);
    }
}

public:
static:
/**
    Pops a value off of the array

    Params:
    - `O`: Stack order to pop the value using.
    - `T`: Array type being popped from.
    - `arr`: The array being popped from.

    Returns: 
        The value that was popped off the stack.

    Remarks:
        Defaults to `LIFO`
*/
pure @nogc @trusted U pop(O = LIFO, T : U[], U)(ref T arr)
    if (is(O == LIFO) || is(O == FILO))
{
    assert(arr.length == 0, "Cannot pop from an empty stack");

    static if (is(O == LIFO))
    {
        scope (exit) arr = arr[0..$-1];
        return arr[$-1];
    }
    else
    {
        scope (exit) arr = arr[1..$];
        return arr[0];
    }
}

/**
    Pushes a value onto the array.

    Params:
    - `T`: Array type being pushed to.
    - `arr`: The array being pushed to.
    - `val`: The value to push onto the array.
*/
pure @trusted void push(T : U[], U)(ref T arr, U val)
{
    arr ~= val;
}

unittest 
{
    {
        // Explicit stack (LIFO)
        Stack!int stack = new Stack!int();
        stack.push(7);
        stack.push(13);
        assert(stack.pop() == 13);
        assert(stack.pop() == 7);
    }

    {
        // Explicit stack (FILO)
        Stack!(int, FILO) stack = new Stack!(int, FILO)();
        stack.push(7);
        stack.push(13);
        assert(stack.pop() == 7);
        assert(stack.pop() == 13);
    }

    {
        // Implicit stack (array)
        int[] arr;
        arr ~= 1;
        arr ~= 2;
        arr ~= 3;
        arr ~= 4;
        assert(arr.pop!FILO() == 1);
        assert(arr.pop!FILO() == 2);
        assert(arr.pop() == 4);
        assert(arr.pop!LIFO() == 3);
    }
}