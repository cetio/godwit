module godwit.backend.stringarraylist;

import godwit.backend.arraylist;
import caiman.traits;

public struct StringArrayList
{
public:
final:
    ArrayList m_elements;

    mixin accessors;
}