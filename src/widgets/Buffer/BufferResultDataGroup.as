////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
//类名重命名
//王红亮，2012-4-26
//
////////////////////////////////////////////////////////////////////////////////
package widgets.Buffer
{

import mx.core.ClassFactory;

import spark.components.DataGroup;

// these events bubble up from the SearchResultItemRenderer
[Event(name="bufferResultClick", type="flash.events.Event")]
[Event(name="bufferResultMouseOver", type="flash.events.Event")]
[Event(name="bufferResultMouseOut", type="flash.events.Event")]

public class BufferResultDataGroup extends DataGroup
{
    public function BufferResultDataGroup()
    {
        super();

        this.itemRenderer = new ClassFactory(BufferResultItemRenderer);
    }
}

}
