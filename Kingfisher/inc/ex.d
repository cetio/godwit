module inc.ex;

public struct EXException
{
public:
    EXException* innerException;

    EXException* getInnerException()
    {
        return innerException;
    }

    void setInnerException(EXException* newInnerException)
    {
        innerException = newInnerException;
    }
}