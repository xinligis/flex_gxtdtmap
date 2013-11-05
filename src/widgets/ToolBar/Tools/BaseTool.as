package widgets.ToolBar.Tools
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.ConfigData;
	
	import mx.modules.Module;
	
	/**
	 * 所有工具的基类，自定义工具必需继承于此。BaseTool定义了工具的所有必需方法，有必要时，请重写。
	 * @author 温杨彪 2012-1-11
	 **/
	public class BaseTool implements ITool
	{
		private var _activated:Boolean;
		
		private var _map:Map;
		
		private var _activateHandler:Function;
		
		private var _deactivateHandler:Function;
		
		private var _configXML:XML;
		
		private var _graphicsLayer:GraphicsLayer;
		
		private var _toolLabel:String;
		
		private var _toolCursor:Class;
		
		private var _tooltip:String;
		
		private var _activeOtherHandler:Function;
		
		private var _runWidgetHandler:Function;
		
		private var _postProcessHandler:Function;
		
		private var _configData:ConfigData;
		
		public function get configData():ConfigData
		{
			return _configData;
		}
		
		public function set configData(value:ConfigData):void
		{
			_configData = value;
		}
		
		public function get postProcessHandler():Function
		{
			return _postProcessHandler;
		}
		
		public function set postProcessHandler(value:Function):void
		{
			_postProcessHandler=value;
		}
		
		public function get runWidgetHandler():Function
		{
			return _runWidgetHandler;
		}
		
		public function set runWidgetHandler(value:Function):void
		{
			_runWidgetHandler=value;
		}
		
		
		public function get toolCursor():Class
		{
			return _toolCursor;
		}
		
		/**
		 * 工具的tooltip
		 **/
		[Bindable]
		public function get tooltip():String
		{
			return _tooltip;
		}
		
		/**
		 * 工具的tooltip
		 **/
		public function set tooltip(value:String):void
		{
			_tooltip=value;
		}
		
		/**
		 * 工具激活时的光标
		 **/
		public function set toolCursor(value:Class):void
		{
			_toolCursor=value;
		}
		
		public function BaseTool()
		{
			_activated=false;
			super();
		}
		
		
		public function set toolLabel(value:String):void
		{
			this._toolLabel=value;
		}
		
		[Bindable]
		public function get toolLabel():String
		{
			return this._toolLabel;
		}
		
		public function activate(params:Object=null):void
		{
			if(activated)
				return;
			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "pan",status: null});
			_activated=true;
			if(_activateHandler!=null)
			{
				_activateHandler.call(null,this);
			}
		}
		
		public function deactivate(params:Object=null):void
		{
			if(_activated==false)
			{
				return;
			}
			_activated=false;
			if(_deactivateHandler!=null)
			{
				_deactivateHandler.call(null,this);
			}
		}
		
		public function set map(value:Map):void
		{
			_map=value;
		}
		public function get map():Map
		{
			return _map;
		}
		
		
		public function get activated():Boolean
		{
			return _activated;
		}
		
		public function set activateHandler(handler:Function):void
		{
			if(handler!=null)
			{
				_activateHandler=handler;
			}
		}
		
		public function set deactivateHandler(handler:Function):void
		{
			_deactivateHandler=handler;
		}
		
		public function set graphicsLayer(value:GraphicsLayer):void
		{
			_graphicsLayer=value;
		}
		
		public function get graphicsLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		public function set configXML(value:XML):void
		{
			_configXML=value;
		}
		
		public function get configXML():XML
		{
			return _configXML;
		}
		
		public function set activeOtherToolorCommandHandler(value:Function):void
		{
			_activeOtherHandler=value;
		}
		
		public function get activeOtherToolorCommandHandler():Function
		{
			return _activeOtherHandler;
		}
	}
}