module godwit.stringarraylist;

import godwit.arraylist;
import godwit.mem.state;

public struct StringArrayList
{
public:
    ArrayList m_elements;

    mixin accessors;
}