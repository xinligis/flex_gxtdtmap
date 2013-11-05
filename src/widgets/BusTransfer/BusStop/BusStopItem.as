package widgets.BusTransfer.BusStop
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	[Bindable]
	public class BusStopItem extends EventDispatcher
	{
		public var stopId:int;
		public var name:String;

		/**
		 * 途经公交线路信息[{oid, name}]
		 */
		public var routes:ArrayCollection;
		
		/**
		 * 是否是第一条数据
		 **/
		public var firstOne:Boolean = false;
		public function BusStopItem()
		{
		}
	}
}