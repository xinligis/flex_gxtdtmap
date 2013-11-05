////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.LayerList
{

import mx.core.ClassFactory;

import spark.components.DataGroup;

// these events bubble up from the BookmarkItemRenderer
public class LayerListDataGroup extends DataGroup
{
    public function LayerListDataGroup()
    {
        super();

        this.itemRenderer = new ClassFactory(LayerListItemRenderer);
    }
}

}
