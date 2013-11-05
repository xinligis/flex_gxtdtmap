package widgets.Print.SettingPanel
{
	import flash.events.Event;
	
	import widgets.Print.element.Element;
	
	
	public class AddPrintElementEvent extends Event
	{
		public var element:Element;
		public function AddPrintElementEvent(ele:Element)
		{
			super("addPrintElement");
			this.element=ele;
		}
	}
}