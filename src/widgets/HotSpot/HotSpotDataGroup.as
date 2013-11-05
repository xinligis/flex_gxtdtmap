package widgets.HotSpot
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	[Event(name="itemClick",type="flash.events.Event")]
	[Event(name="expandChildren",type="flash.events.Event")]
	public class HotSpotDataGroup extends DataGroup
	{
		private var _type:String = "root";
		public function set type(value:String):void
		{
			_type = value;
			if(_type == "root")
			{
				itemRenderer = new ClassFactory(HotSpotRootItemRenderer);
			}
			else if(_type == "child")
			{
				itemRenderer = new ClassFactory(HotSpotChildItemRenderer);
			}
		}
		public function HotSpotDataGroup()
		{
			super();
		}
	}
}