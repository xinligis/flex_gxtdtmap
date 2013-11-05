package widgets.ToolBar
{
	import flash.events.Event;
	
	public class RunWidegtEvent extends Event
	{
		public static const RunWidegt:String="RunWidgetCommand";
		
		public var source:Object;
		public var widgetUrl:String;
		public var callback:Function
		public var data:Object;
		
		public function RunWidegtEvent(source:Object,url:String,bubbles:Boolean,callback:Function=null)
		{
			super(RunWidegt, bubbles);
			this.source=source;
			this.widgetUrl=url;
			this.callback=callback;
		}
	}
}