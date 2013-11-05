package widgets.BusTransfer.BusRoute
{
	import mx.core.ClassFactory;
	
	import spark.components.List;
	[Event(name="busStopItemOver",type="flash.events.Event")]
	[Event(name="busStopItemClick",type="flash.events.Event")]
	public class BusStopList extends List
	{
		public function BusStopList()
		{
			super();
			itemRenderer = new ClassFactory(BusstopListRenderer);
		}
	}
}