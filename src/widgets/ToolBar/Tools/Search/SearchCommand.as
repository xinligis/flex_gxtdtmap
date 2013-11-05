package widgets.ToolBar.Tools.Search
{
	import widgets.ToolBar.Tools.BaseCommand;
	
	public class SearchCommand extends BaseCommand
	{
		private var _widgeturl:String;
		private var _isRunWidget:Boolean=false;
		public function SearchCommand()
		{
			super();
		}
		public override function set configXML(value:XML):void
		{
			super.configXML=value;
			_isRunWidget=true;
			_widgeturl=String(configXML.widget[0].@url);
		}
		public override function get isRunWidget():Boolean
		{
			return _isRunWidget;
		}
		public override function get widgetUrl():String
		{
			return _widgeturl;
		}
	}
}