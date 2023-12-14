module vm.precode;

public struct Precode
{
public:
    byte[size_t.sizeof * 2] data;

    byte[] getData()
        scope return
    {
        return data;
    }

    void setData(byte[] newData)
    {
        data = newData.dup;
    }
}