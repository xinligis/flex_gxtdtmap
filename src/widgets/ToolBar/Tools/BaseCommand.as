package widgets.ToolBar.Tools
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	
	import mx.modules.Module;
	
	public class BaseCommand implements ICommand
	{
		private var _map:Map;
		private var _configXml:XML;
		private var _excuteHandler:Function;
		private var _graphicsLayer:GraphicsLayer;
		[Bindable]
		private var _commandLabel:String;
		
		private var _postProcessHandler:Function;
		
		public function get postProcessHandler():Function
		{
			return _postProcessHandler;
		}
		
		public function set postProcessHandler(value:Function):void
		{
			_postProcessHandler=value;
		}
		
		public function set commandLabel(value:String):void
		{
			this._commandLabel=value;
		}
		
		public function get commandLabel():String
		{
			return this._commandLabel;
		}
		
		public function BaseCommand()
		{
			super();
		}
		
		public function set map(value:Map):void
		{
			_map=value;
		}
		
		public function get map():Map
		{
			return _map;
		}
		
		public function set configXML(value:XML):void
		{
			_configXml=value;
		}
		
		public function get configXML():XML
		{
			return _configXml;
		}
		
		public function get graphicsLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		public function set graphicsLayer(value:GraphicsLayer):void
		{
			_graphicsLayer=value;
		}
		
		public function set excuteHandler(value:Function):void
		{
			_excuteHandler=value;
		}
		
		public function excute(params:Object=null):void
		{
			if(_excuteHandler!=null)
			{
				_excuteHandler.call(null,this);
			}
		}
		
		public function get isRunWidget():Boolean
		{
			return false;
		}
		
		public function get widgetUrl():String
		{
			return "";
		}
	}
}