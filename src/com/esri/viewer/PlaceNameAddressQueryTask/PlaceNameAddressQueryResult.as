package com.esri.viewer.PlaceNameAddressQueryTask
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public final class PlaceNameAddressQueryResult extends EventDispatcher
	{
		public var features:Array;
		/*public var geometryType:String;
		public var status:String;*/
		public var count:int;
		public function PlaceNameAddressQueryResult(target:IEventDispatcher=null)
		{
			super(target);
			features = [];
		}
	}
}