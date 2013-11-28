package widgets.Search
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class BannerObj extends EventDispatcher
	{
		public var name:String;
		public var url:String;
		public var img:String;
		
		public function BannerObj()
		{
		}
	}
}