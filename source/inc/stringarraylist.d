module godwit.stringarraylist;

import godwit.arraylist;
import godwit.llv.traits;

public struct StringArrayList
{
public:
    ArrayList m_elements;

    mixin accessors;
}