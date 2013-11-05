package widgets.TabbedWidgetContainer.events
{
	import flash.events.Event;

	public class ClosableTabEvent extends Event
	{
		public static const TAB_CLOSE:String = "tabClose";
	
		public var tabIndex:Number;
		
		public function ClosableTabEvent(type:String, tabIndex:Number=-1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.tabIndex = tabIndex;
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ClosableTabEvent(type, tabIndex, bubbles, cancelable);
		}
		
	}
}