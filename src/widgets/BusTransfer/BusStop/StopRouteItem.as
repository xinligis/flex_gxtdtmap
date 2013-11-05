package widgets.BusTransfer.BusStop
{
	import flash.events.EventDispatcher;
	[Bindable]
	/**
	 * 经过该站点的公交线路显示信息
	 */
	public class StopRouteItem extends EventDispatcher
	{
		public var routeId:int;
		public var name:String;
		/**
		 *  是否上行
		 */
		public var isUp:Boolean;
	}
}