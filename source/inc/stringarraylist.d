module godwit.stringarraylist;

import godwit.arraylist;
import godwit.collections.state;

public struct StringArrayList
{
public:
    ArrayList m_elements;

    mixin accessors;
}