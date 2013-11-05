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

import com.esri.ags.Graphic;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

import flash.events.EventDispatcher;

[Bindable]
public class BufferResult extends EventDispatcher
{
	public var index:uint; //所在的序号，基数为0
    public var title:String;

    public var symbol:Symbol;

    public var content:String;

    public var point:MapPoint;

    public var link:String;

	public var multimedia:Array;
    //public var geometry:Geometry;
	
	public var graphic:Graphic;
}

}
