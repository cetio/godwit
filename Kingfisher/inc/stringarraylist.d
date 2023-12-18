module inc.stringarraylist;

import inc.arraylist;
import state;

public struct StringArrayList
{
public:
    ArrayList m_elements;

    mixin accessors;
}