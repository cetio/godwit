module godwit.stringarraylist;

import godwit.arraylist;
import godwit.state;

public struct StringArrayList
{
public:
    ArrayList m_elements;

    mixin accessors;
}