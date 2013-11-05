package widgets.BusTransfer.BusRoute
{
	import com.esrichina.publictransportation.RouteResult;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	[Bindable]
	public class BusRouteItem extends EventDispatcher
	{
		public var routeId:int;
		public var name:String;
		/**
		 * 上行的基本信息项集合
		 */
		public var upBasicInfos:IList;
		/**
		 * 下行的基本信息项集合
		 */
		public var downBasicInfos:IList;		
		/**
		 * 上行站点
		 */
		public var upStops:ArrayCollection;
		/**
		 * 下行站点
		 */
		public var downStops:ArrayCollection;
		
		public var solveResult:RouteResult;
		
		public var firstOne:Boolean = false;
		
		public function BusRouteItem()
		{
		}
	}
}