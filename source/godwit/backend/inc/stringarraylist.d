module godwit.backend.inc.stringarraylist;

import godwit.backend.inc.arraylist;
import caiman.traits;

public struct StringArrayList
{
public:
final:
    ArrayList m_elements;

    mixin accessors;
}