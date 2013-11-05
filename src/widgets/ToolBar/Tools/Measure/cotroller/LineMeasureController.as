package widgets.ToolBar.Tools.Measure.cotroller
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.Units;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.LineSymbol;
	import com.esri.ags.symbols.MarkerSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.utils.GeometryUtil;
	import com.esri.viewer.utils.Hashtable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import mx.controls.Alert;
	import mx.graphics.SolidColor;
	
	import spark.components.BorderContainer;
	import spark.components.Label;
	import spark.components.TextArea;
	
	import widgets.ToolBar.Tools.Measure.Element.PolylineElement;
	import widgets.ToolBar.Tools.Measure.MeasureUtil;

	/**
	 * 开始测量事件
	 **/
	[Event(name="startMeasure",type="flash.events.Event")]
	/**
	 * 测量结束事件
	 **/
	[Event(name="measureCompelet",type="flash.events.Event")]
	
	
	/**
	 * 线段测量的控制器，用于线段的测量、测量时的Feedback效果，tooltip展示和创建结果显示
	 * @author 温杨彪
	 **/
	public class LineMeasureController extends EventDispatcher
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
		 * 正在画的线
		 **/
		private var _line:Polyline=null;
		
		
		private var _lineGraphic:Graphic=null;
		
		private var _config:XML=null;
		
		/**
		 * 已经加的点
		 **/
		private var _pts:Array=[];
		
		/**
		 * 绑定的graphicLayer
		 **/
		private var _graphicsLayer:GraphicsLayer=null;
		
		private var _srtype:String;
		public function set graphicsLayer(value:GraphicsLayer):void
		{
			_graphicsLayer=value;
		}
		
		public function get graphicsLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		/**
		 * 线的符号
		 **/
		private var _lineSymbol:LineSymbol=null;
		
		/**
		 * 是否显示tooltip
		 **/
		private var _showTooltip:Boolean=false;
		public function set showTooltip(value:Boolean):void
		{
			if(_showTooltip==value)
				return;
			_showTooltip=value;
			if(_showTooltip)
			{
				_map.addChild(_toolTip);
			}
			else
			{
				_map.removeChild(_toolTip);
			}
		}
		
		/**
		 * 测量时，鼠标移动显示的tip的文本
		 **/
		private var _mesureToolTipText:String="";
		
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
		 * 大单位与米的转换系数。比如1公里==1000米，那么系数就是1000
		 **/
		private var _largeUnitConversion:Number;
		
		/**
		 * 小单位与米的转换系数。比如1公里==1000米，那么系数就是1000
		 **/
		private var _smallUnitConversion:Number;
		
		/**
		 * 当前是否处于绘制的feedback状态
		 **/
		private var _isFeedBack:Boolean=false;
		
		/**
		 * 当前需要显示的线要素
		 **/
		private var _lineElement:PolylineElement=null;
		
		/**
		 * 显示的toolTip容器
		 **/
		private var _toolTip:BorderContainer;
		private var _toolTipText:TextArea;
		
		private var _lineElementsTable:Hashtable;
		private var _lineId:int=0;
		
		
		
		public function LineMeasureController(config:XML,map:Map=null,graphicsLayer:GraphicsLayer=null)
		{
			_config=config;
			_map=map;
			_isActive=false;
			_graphicsLayer=graphicsLayer;
			_lineElementsTable=new Hashtable();
			
			//创建在测量时，鼠标移动的tooltip
			_toolTip=new BorderContainer();
			_toolTip.setStyle("borderColor",String(config.lineController.tooltip.@borderColor));
			_toolTip.setStyle("borderWidth",String(config.lineController.tooltip.@borderWidth));
			_toolTip.width=Number(config.lineController.tooltip.@width);
			_toolTip.height=Number(config.lineController.tooltip.@height);
			_toolTipText=new TextArea();
			_toolTipText.setStyle("contentBackgroundColor",String(config.lineController.tooltip.@backgroundColor));
			_toolTipText.setStyle("borderVisible","false");
			_toolTipText.width=Number(config.lineController.tooltip.@width)-2;
			_toolTipText.height=Number(config.lineController.tooltip.@height)-2;
			_toolTipText.verticalCenter=0;
			_toolTipText.horizontalCenter=0;
			_toolTip.addElement(_toolTipText);
			
			//线在绘制时的样式
			_lineSymbol=new SimpleLineSymbol("solid",
				uint(config.lineController.line.@color),1,
				uint(config.lineController.line.@size));
			
			_mesureToolTipText=config.lineController.tooltip.@text;
			_mesureToolTipText=MeasureUtil.StringReplaceAll(_mesureToolTipText,"&lt","<");
			_mesureToolTipText=MeasureUtil.StringReplaceAll(_mesureToolTipText,"&gt",">");
			
			//单位的显示精度
			_smallUnitPrecision=int(config.distanceunit.smallunit.@precision);
			_largeUnitPrecision=int(config.distanceunit.largeunit.@precision);
			
			//单位的显示
			_smallUnitLabel=String(config.distanceunit.smallunit.@label);
			_largeUnitLabel=String(config.distanceunit.largeunit.@label);
			
			//单位的转换系数
			_smallUnitConversion=Number(config.distanceunit.smallunit.@conversion);
			_largeUnitConversion=Number(config.distanceunit.largeunit.@conversion)
			_scale=Number(config.distanceunit.scale);
			
			_srtype = String(config.srtype);
		}
		
		/**
		 * 开始测量
		 **/
		public function doMeasure():void
		{
			//如果已经在测量，则返回
			if(_isActive)
			{
				return;
			}
			_isActive=true;
			_lineElement=new PolylineElement(_config);
			_lineElement.id="line"+_lineId.toString();
			_lineElementsTable.add(_lineElement.id,_lineElement);
			_lineId++;
			
			_lineElement.graphcisLayer=_graphicsLayer;
			_lineElement.lineSymbol=_lineSymbol;
			_pts=[];
			
			if(_map!=null)
			{
				showTooltip=true;
				_toolTip.x=-100;
				_toolTip.y=-100;
				var text:String=_config.lineController.tooltip.@starttext;
				text=MeasureUtil.StringReplaceAll(text,"&lt","<");
				text=MeasureUtil.StringReplaceAll(text,"&gt",">");
				_toolTipText.textFlow=TextConverter.importToFlow(text,TextConverter.TEXT_FIELD_HTML_FORMAT);
				_map.addEventListener(MouseEvent.CLICK,map_mouseClickHandler);
				_map.addEventListener(MouseEvent.DOUBLE_CLICK,map_mouseDBClickHandler);
				_map.addEventListener(MouseEvent.MOUSE_MOVE,map_mouseMoveHandler);
				if(_graphicsLayer==null)
				{
					_graphicsLayer=new GraphicsLayer();
					_map.addLayer(_graphicsLayer);
				}
				_lineGraphic=new Graphic(null,_lineSymbol);
				
			}
			else
			{
				Alert.show("map is null");
			}
		}
		
		/**
		 * 失效
		 **/
		public function deactivate():void
		{
			if(_isActive==false)
				return;
			_isActive=false;
			_map.removeEventListener(MouseEvent.CLICK,map_mouseClickHandler);
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK,map_mouseDBClickHandler);
			_map.removeEventListener(MouseEvent.MOUSE_MOVE,map_mouseMoveHandler);
			if(_lineElement!=null&&_lineElement.compeleted==false)
			{
				_lineElement.clean();
				_lineElement=null;
			}
			showTooltip=false;
			_graphicsLayer.remove(_lineGraphic);
		}
		
		private function map_mouseMoveHandler(event:MouseEvent):void
		{
			_toolTip.x=map.contentMouseX+25;
			_toolTip.y=map.contentMouseY;
			if(_pts.length==0||_isFeedBack==false)
			{
				return;
			}
			//实时测量，把结果显示在tip上
			var pt:MapPoint=_map.toMapFromStage(event.stageX,event.stageY);
			_line.setPoint(0,_pts.length,pt);
			var results:Array = [];
			if(_srtype == "project")
			{
				//平面坐标计算
				results = [projectLengths(_line)]
			}
			else
			{
				//地理坐标计算
				results= GeometryUtil.geodesicLengths([_line],com.esri.ags.Units.METERS);
			}
			var length:Number=results[0];
			var text:String=replaceLengthAndUnit(_mesureToolTipText,results[0])
			_toolTipText.textFlow=TextConverter.importToFlow(text,TextConverter.TEXT_FIELD_HTML_FORMAT);
			_lineGraphic.refresh();
		}
		
		private function map_mouseClickHandler(event:MouseEvent):void
		{
			if(event.target is Graphic)
			{
				var g:Graphic=event.target as Graphic;
			}
			
			_isFeedBack=false
			var pt:MapPoint=_map.toMapFromStage(event.stageX,event.stageY);
			
			//如果不设置延时，则双击事件无法捕获
			setTimeout(function():void
			{
				
				_pts.push(pt);
				if(_pts.length==1)
				{
					_graphicsLayer.add(_lineGraphic);
					//第一个点
					_line=new Polyline(null,_map.spatialReference);
					_line.addPath([pt]);
					_lineGraphic.geometry=_line;
					_lineElement.setStartPoint(pt);
					map.doubleClickZoomEnabled=false;
					dispatchEvent(new Event(START_MEASURE));
				}
				else
				{
					_line.setPoint(0,_pts.length-1,pt);
					var results:Array = [];
					if(_srtype == "project")
					{
						//平面坐标计算
						results = [projectLengths(_line)]
					}
					else
					{
						//地理坐标计算
						results= GeometryUtil.geodesicLengths([_line],com.esri.ags.Units.METERS);
					}
					_lineElement.setPartResult(pt,results[0],_line);
					_lineGraphic.refresh();
				}
				_isFeedBack=true;
			},200)
		}
		
		/**
		 * 测量两点间线的长度，平面坐标
		 * @author 温杨彪；2013-3-4
		 **/
		private function projectLengths(line:Polyline):Number
		{
			var lineLength:Number = 0;
			for each(var ring:Array in line.paths)
			{
				var startPoint:MapPoint = null;
				var endPoint:MapPoint = null;
				for each(var mPt:MapPoint in ring)
				{
					//第一个点
					if(startPoint == null)
					{
						startPoint = mPt;
						continue;
					}
					endPoint = mPt;
					
					var dx:Number = endPoint.x - startPoint.x;
					var dy:Number = endPoint.y - startPoint.y;
					
					var partLength:Number = Math.sqrt(dx*dx + dy*dy);
					lineLength += partLength;
					startPoint = endPoint;
				}
			}
			return lineLength;
		}
		
		private function map_mouseDBClickHandler(event:MouseEvent):void
		{
			compelete();
		}
		
		
		/**
		 * 测量完成
		 **/
		private function compelete():void
		{
			trace("compelete");
			_isActive=false;
			showTooltip=false;
			_lineElement.compeleted=true;
			_lineGraphic.visible=false;
			_map.removeEventListener(MouseEvent.CLICK,map_mouseClickHandler);
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK,map_mouseDBClickHandler);
			_map.removeEventListener(MouseEvent.MOUSE_MOVE,map_mouseMoveHandler);
			dispatchEvent(new Event(MEASURE_COMPELET));
		}
		
		/**
		 * 根据长度，替换Tip显示的文本
		 **/
		private function replaceLengthAndUnit(text:String,length:Number):String
		{
			var newtext:String=text;
			if(length>_scale)
			{
				newtext=newtext.replace("%length%",(length/_largeUnitConversion).toFixed(_largeUnitPrecision));
				newtext=newtext.replace("%unit%",_largeUnitLabel);
			}
			else
			{
				newtext=newtext.replace("%length%",(length/_smallUnitConversion).toFixed(_smallUnitPrecision));
				newtext=newtext.replace("%unit%",_smallUnitLabel);
			}
			return newtext;
		}
		
	}
}