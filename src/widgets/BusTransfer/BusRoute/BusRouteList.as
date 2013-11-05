package widgets.BusTransfer.BusRoute
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	/**
	 * 查询线路详细信息事件
	 **/
	[Event(name="queryDetail",type="flash.events.Event")]
	/**
	 * 显示线路
	 **/
	[Event(name="showBusRoute",type="flash.events.Event")]
	
	[Event(name="busStopItemOver",type="flash.events.Event")]
	[Event(name="busStopItemClick",type="flash.events.Event")]
	public class BusRouteList extends DataGroup
	{
		public function BusRouteList()
		{
			super();
			itemRenderer = new ClassFactory(BusRouteItemRenderer);
		}
	}
}