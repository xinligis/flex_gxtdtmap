package widgets.BusTransfer.BusStop
{
	import com.esri.ags.Graphic;
	
	import flash.events.EventDispatcher;

	[Bindable]
	/**
	 * 公交站牌上的站点信息显示
	 */
	public class RouteStopInfoItem extends EventDispatcher
	{
		public var name:String;
		public var graphic:Graphic;
		public var selected:Boolean = false;
	}
}