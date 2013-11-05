package widgets.Search
{
	import flash.events.Event;
	
	public class PageChangeEvent extends Event
	{
		public function PageChangeEvent(type:String = "PageChanged", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var currentPage:int = -1;
	}
}