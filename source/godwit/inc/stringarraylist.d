module godwit.stringarraylist;

import godwit.arraylist;
import caiman.traits;

public struct StringArrayList
{
public:
final:
    ArrayList m_elements;

    mixin accessors;
}