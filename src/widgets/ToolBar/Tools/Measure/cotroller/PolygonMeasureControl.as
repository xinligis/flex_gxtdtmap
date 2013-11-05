package widgets.ToolBar.Tools.Measure.cotroller
{
	import com.esri.ags.Map;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.tools.DrawTool;
	import com.esri.ags.utils.GeometryUtil;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.events.DragEvent;
	
	import widgets.ToolBar.Tools.Measure.Element.PolygonElement;

	public class PolygonMeasureControl extends EventDispatcher
	{
		
		/**
		 * 开始测量事件类型
		 **/
		public static const START_MEASURE:String="startMeasure";
		
		/**
		 * 测量完成事件类型
		 **/
		public static const MEASURE_COMPELET:String="measureCompelet";
		
		/**
		 * 绑定的地图
		 **/
		private var _map:Map;
		public function set map(value:Map):void
		{
			_map=value;
		}
		public function get map():Map
		{
			return _map;
		}
		/**
		 * 是否在激活的状态
		 **/
		private var _isActive:Boolean=false;
		
		/**
		 * 绑定的graphicLayer
		 **/
		private var _graphicsLayer:GraphicsLayer=null;
		public function set graphicsLayer(value:GraphicsLayer):void
		{
			_graphicsLayer=value;
		}
		
		public function get graphicsLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		private var _drawTool:DrawTool;
		
		private var _polygonSymbol:SimpleFillSymbol;
		
		private var _polygonElement:PolygonElement;
		
		private var _config:XML;
		
		private var _srtype:String;
		
		/**
		 * 开始测量事件
		 **/
		[Event(name="startMeasure",type="flash.events.Event")]
		/**
		 * 测量结束事件
		 **/
		[Event(name="measureCompelet",type="flash.events.Event")]
		public function PolygonMeasureControl(config:XML,map:Map,graphicsLayer:GraphicsLayer=null)
		{
			_map=map;
			_config=config;
			_graphicsLayer=graphicsLayer;
			//创建默认polygon
			var outLineSym:SimpleLineSymbol=new SimpleLineSymbol("solid",
				uint(_config.polygonContrller.border.@color),1,
				Number(_config.polygonContrller.border.@size));
				
			_polygonSymbol=new SimpleFillSymbol("solid",
				uint(_config.polygonContrller.fillsymbol.@color),
				Number(_config.polygonContrller.fillsymbol.@alpha),outLineSym);
			
			//创建drawTool
			_drawTool=new DrawTool(map);
			_drawTool.fillSymbol=_polygonSymbol;
			_drawTool.addEventListener(DrawEvent.DRAW_END,drawTool_drawEndHandler);
			_drawTool.showDrawTips=true;
			_drawTool.addEventListener(DrawEvent.DRAW_START,drawTool_drawStartHandler);
			
			_srtype = String(_config.srtype);
			
			_isActive=false;
		}
		
		public function doMeasure():void
		{
			if(_isActive)
				return;
			_isActive=true;
			_drawTool.activate(DrawTool.POLYGON);
			_polygonElement=new PolygonElement(_config);
			_polygonElement.graphcisLayer=_graphicsLayer
		}
		
		private function drawTool_drawStartHandler(event:DrawEvent):void
		{
			dispatchEvent(new Event(START_MEASURE));
		}
		
		private function drawTool_drawEndHandler(event:DrawEvent):void
		{
			_isActive=false;
			_drawTool.deactivate();
			var results:Array = [];
			var measureGeo:Geometry = event.graphic.geometry
			if(_srtype == "project")
			{
				measureGeo = WebMercatorUtil.webMercatorToGeographic(measureGeo);
			}
			results = GeometryUtil.geodesicAreas([measureGeo],"esriSquareMeters");
			_polygonElement.setResult(results[0],event.graphic.geometry as Polygon);
			dispatchEvent(new Event(MEASURE_COMPELET));
		}
		
		public function deactivate():void
		{
			if(_isActive==false)
				return;
			_drawTool.deactivate();
			_isActive=false;
		}
	}
}