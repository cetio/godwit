module godwit.stringarraylist;

import godwit.arraylist;
import godwit.llv.traits;

public struct StringArrayList
{
public:
final:
    ArrayList m_elements;

    mixin accessors;
}