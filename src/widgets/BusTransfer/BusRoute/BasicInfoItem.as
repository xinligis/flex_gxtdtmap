package widgets.BusTransfer.BusRoute
{
	import flash.events.EventDispatcher;
	[Bindable]
	/**
	 * 公交线路的基本信息项，如首末车时间，2012-8-29
	 */
	public class BasicInfoItem extends EventDispatcher
	{
		public var label:String;
		public var value:String;
		public function BasicInfoItem(label:String, value:String = ""):void
		{
			this.label = label;
			this.value = value;
		}
	}
}