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
package widgets.POISearch
{

import com.esri.ags.Graphic;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

import flash.events.EventDispatcher;

[Bindable]
public class SearchResult extends EventDispatcher
{
	public var index:uint; //所在的序号，基数为0
    public var title:String;
    public var symbol:Symbol;
    public var content:String;
    public var point:MapPoint;
    public var link:String;
	public var multimedia:Array;
	public var graphic:Graphic;
}

}
