package widgets.ToolBar.Tools.Measure
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.modules.Module;
	
	import spark.components.Label;
	import spark.components.TitleWindow;
	
	import widgets.ToolBar.Tools.BaseTool;
	import widgets.ToolBar.Tools.ITool;
	import widgets.ToolBar.Tools.Measure.cotroller.PanController;
	import widgets.ToolBar.Tools.Measure.cotroller.PolygonMeasureControl;
	
	public class PolygonTool extends BaseTool
	{
		private var _panController:PanController=null;
		
		private var _graphicsLayer:GraphicsLayer;
		
		private var _pmc:PolygonMeasureControl;		
		private var _cursorId:int;
		
		[Embed("assets/images/measure/cursor.png")]
		private var _cursor:Class;
		
		
		public override function set configXML(value:XML):void
		{
			super.configXML=value;
			_pmc=new PolygonMeasureControl(configXML,map,graphicsLayer);
			_pmc.addEventListener(PolygonMeasureControl.MEASURE_COMPELET,measureCompelethandler);
			_panController=new PanController(map);
		}
		
		public function PolygonTool()
		{
			super();
		}
		
		private function measureCompelethandler(event:Event):void
		{
			deactivate();
		}
		
		public override function activate(params:Object=null):void
		{
			super.activate(params);
			map.doubleClickZoomEnabled=false;;
			_panController.start();
			_pmc.doMeasure();
			map.addEventListener(MouseEvent.MOUSE_OVER,map_mouseOverHandler);
			map.addEventListener(MouseEvent.MOUSE_OUT,map_mouseOutHandler);
		}
		
		private function map_mouseOverHandler(event:MouseEvent):void
		{
			_cursorId=map.cursorManager.setCursor(_cursor);
		}
		
		private function map_mouseOutHandler(event:MouseEvent):void
		{
			map.cursorManager.removeCursor(_cursorId);
		}
		
		public override function deactivate(params:Object=null):void
		{
			super.deactivate(params);
			map.doubleClickZoomEnabled=true;
			_pmc.deactivate();
			_panController.stop();
			map.cursorManager.removeCursor(_cursorId);
			
			map.removeEventListener(MouseEvent.MOUSE_OVER,map_mouseOverHandler);
			map.removeEventListener(MouseEvent.MOUSE_OUT,map_mouseOutHandler);
		}
	}
}