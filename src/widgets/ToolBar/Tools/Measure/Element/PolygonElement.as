package widgets.ToolBar.Tools.Measure.Element
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Units;
	import com.esri.ags.events.EditEvent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.TextSymbol;
	import com.esri.ags.tools.EditTool;
	import com.esri.ags.utils.GeometryUtil;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import flash.events.MouseEvent;

	public class PolygonElement
	{
		private var _polygonGraphic:Graphic;
		private var _graphicsLayer:GraphicsLayer;
		private var _graphics:Array;
		/**测量是否完成**/
		private var _compelete:Boolean=false;
		
		/**
		 * 单位界限
		 **/
		private var _scale:Number;
		
		/**
		 * 大单位的精度
		 **/
		private var _largeUnitPrecision:int;
		
		/**
		 * 小单位的精度
		 **/
		private var _smallUnitPrecision:int;
		
		/**
		 * 大单位的显示
		 **/
		private var _largeUnitLabel:String;
		
		/**
		 * 小单位的显示
		 **/
		private var _smallUnitLabel:String;
		
		/**
		 * 大单位与平方米的转换系数。比如1平方公里==1000000米，那么系数就是1000000
		 **/
		private var _largeUnitConversion:Number;
		
		/**
		 * 小单位与平方米的转换系数。比如1平方公里==1000000米，那么系数就是1000000
		 **/
		private var _smallUnitConversion:Number;
		
		private var _srtype:String;
		
		public function get compeleted():Boolean
		{
			return _compelete;
		}
		public function set compeleted(value:Boolean):void
		{
			_compelete=value;
		}
		
		public function get graphcisLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		public function set graphcisLayer(value:GraphicsLayer):void
		{
			_graphicsLayer=value;
		}
		
		private var _editTool:EditTool;
		
		private var _config:XML;
		
		private var _resultTipGraphic:Graphic;
		
		private var _deleteGraphic:Graphic;
		
		public function PolygonElement(config:XML)
		{
			_config=config;
			
			//创建polygon符号样式
			var outLineSym:SimpleLineSymbol=new SimpleLineSymbol("solid",
				uint(_config.polygonElement.border.@color),1,
				Number(_config.polygonElement.border.@size));
			var polygonSymbol:SimpleFillSymbol=new SimpleFillSymbol("solid",
				uint(_config.polygonElement.fillsymbol.@color),
				Number(_config.polygonElement.fillsymbol.@alpha),outLineSym);
			
			_polygonGraphic=new Graphic(null,polygonSymbol);
			
			//单位的显示精度
			_smallUnitPrecision=int(config.areaunit.smallunit.@precision);
			_largeUnitPrecision=int(config.areaunit.largeunit.@precision);
			
			//单位的显示
			_smallUnitLabel=String(config.areaunit.smallunit.@label);
			_largeUnitLabel=String(config.areaunit.largeunit.@label);
			
			//单位的转换系数
			_smallUnitConversion=Number(config.areaunit.smallunit.@conversion);
			_largeUnitConversion=Number(config.areaunit.largeunit.@conversion);
			
			_scale=Number(config.areaunit.scale);
			_graphics=[];
			
			_srtype = String(config.srtype);
			
		}
		
		private function polygon_updateHandler(event:EditEvent):void
		{
			var measureGeometry:Geometry = _polygonGraphic.geometry;
			if(_srtype == "project")
			{
				measureGeometry = WebMercatorUtil.webMercatorToGeographic(measureGeometry);
			}
			var results:Array=GeometryUtil.geodesicAreas([measureGeometry],com.esri.ags.Units.SQUARE_METERS);
			var text:String=_config.polygonElement.displayLabel.@text;
			text=replaceAreaAndUnit(text,results[0]);
			var txtSymbol:TextSymbol=new TextSymbol();
			txtSymbol.text=text;
			txtSymbol.color=_config.polygonElement.displayLabel.@color;
			txtSymbol.background=true;
			txtSymbol.backgroundColor=_config.polygonElement.displayLabel.@backgroundColor;
			txtSymbol.border=true;
			txtSymbol.borderColor=_config.polygonElement.displayLabel.@borderColor;
			txtSymbol.xoffset=_config.polygonElement.displayLabel.@xoffset;
			txtSymbol.yoffset=_config.polygonElement.displayLabel.@yoffset;
			
			var polygon:Polygon=_polygonGraphic.geometry as Polygon; 
			var lastRing:Array=polygon.rings[polygon.rings.length-1];
			_resultTipGraphic.geometry=lastRing[lastRing.length-1];
			_resultTipGraphic.symbol=txtSymbol;
			
			_deleteGraphic.geometry=lastRing[lastRing.length-1];
			
			//保证结果显示和删除graphic始终处于最上面
			_graphicsLayer.remove(_deleteGraphic);
			_graphicsLayer.remove(_resultTipGraphic);
			
			_graphicsLayer.add(_deleteGraphic);
			_graphicsLayer.add(_resultTipGraphic);
		}
		
		public function setResult(result:Number,polygon:Polygon):void
		{
			//结果面
			_polygonGraphic.geometry=polygon;
			_graphicsLayer.add(_polygonGraphic);
			_graphics.push(_polygonGraphic);
			
			var text:String=_config.polygonElement.displayLabel.@text;
			text=replaceAreaAndUnit(text,result);
			
			//测量结果tip
			var txtSymbol:TextSymbol=new TextSymbol();
			txtSymbol.text=text;
			txtSymbol.color=_config.polygonElement.displayLabel.@color;
			txtSymbol.background=true;
			txtSymbol.backgroundColor=_config.polygonElement.displayLabel.@backgroundColor;
			txtSymbol.border=true;
			txtSymbol.borderColor=_config.polygonElement.displayLabel.@borderColor;
			txtSymbol.xoffset=_config.polygonElement.displayLabel.@xoffset;
			txtSymbol.yoffset=_config.polygonElement.displayLabel.@yoffset;
			
			var lastRing:Array=polygon.rings[polygon.rings.length-1];
			
			_resultTipGraphic=new Graphic(lastRing[lastRing.length-1],txtSymbol);
			_graphicsLayer.add(_resultTipGraphic);
			_graphics.push(_resultTipGraphic);
			
			//清除按钮
			var markerSym:PictureMarkerSymbol=new PictureMarkerSymbol(String(_config.polygonElement.deleteButton.symbol.@source));
			markerSym.xoffset=Number(String(_config.polygonElement.deleteButton.symbol.@xoffset));
			markerSym.yoffset=Number(String(_config.polygonElement.deleteButton.symbol.@yoffset));
			_deleteGraphic=new Graphic(_resultTipGraphic.geometry,markerSym);
			_deleteGraphic.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
			{
				clean();
			});
			_deleteGraphic.toolTip=_config.polygonElement.deleteButton.symbol.@tooltip;
			_deleteGraphic.buttonMode=true;
			_graphicsLayer.add(_deleteGraphic);
			_graphics.push(_deleteGraphic);
			_compelete=true;
			_editTool=new EditTool(_graphicsLayer.map);
			_editTool.addEventListener(EditEvent.GEOMETRY_UPDATE,polygon_updateHandler);
			_polygonGraphic.addEventListener(MouseEvent.CLICK,polygon_clickHandler);
		}
		
		private function polygon_clickHandler(event:MouseEvent):void
		{
			_polygonGraphic.removeEventListener(MouseEvent.CLICK,polygon_clickHandler);
			_graphicsLayer.map.addEventListener(MouseEvent.CLICK,map_clickHandler);
			
			_editTool.activate(EditTool.EDIT_VERTICES,[_polygonGraphic]);
			event.stopPropagation();
		}
		private function map_clickHandler(event:MouseEvent):void
		{
			_editTool.deactivate();
			_graphicsLayer.map.removeEventListener(MouseEvent.CLICK,map_clickHandler);
			_polygonGraphic.addEventListener(MouseEvent.CLICK,polygon_clickHandler);
		}
		
		public function clean():void
		{
			_editTool.deactivate();
			_graphicsLayer.map.removeEventListener(MouseEvent.CLICK,map_clickHandler);
			_graphicsLayer.clear();
		}
		
		/**
		 * 根据长度，替换Tip显示的文本
		 **/
		private function replaceAreaAndUnit(text:String,area:Number):String
		{
			var newtext:String=text;
			if(area>_scale)
			{
				newtext=newtext.replace("%area%",(area/_largeUnitConversion).toFixed(_largeUnitPrecision));
				newtext=newtext.replace("%unit%",_largeUnitLabel);
			}
			else
			{
				newtext=newtext.replace("%area%",(area/_smallUnitConversion).toFixed(_smallUnitPrecision));
				newtext=newtext.replace("%unit%",_smallUnitLabel);
			}
			return newtext;
		}
	}
}