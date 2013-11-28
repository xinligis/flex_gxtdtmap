package widgets.ToolBar.Tools.Measure.Element
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.Units;
	import com.esri.ags.events.EditEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.LineSymbol;
	import com.esri.ags.symbols.MarkerSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.TextSymbol;
	import com.esri.ags.tools.EditTool;
	import com.esri.ags.utils.GeometryUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 一条测量线段在地图上的展示样式，包括起点、线段、节点、终点和关闭按钮的样式及相关控制
	 * @author 温杨彪，2011-12-27
	 * @Modify 2012-1-16添加了节点编辑功能
	 **/
	public class PolylineElement
	{
		private var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id=value;
		}
		
		/**鼠标单点后显示的样式**/
		private var _markerSymbol:SimpleMarkerSymbol;
		
		/**测量线的符号样式**/
		private var _lineSymbol:LineSymbol;
		public function get lineSymbol():LineSymbol
		{
			return _lineSymbol;
		}
		public function set lineSymbol(value:LineSymbol):void
		{
			_lineSymbol=value;
			if(_lineGraphic!=null)
			{
				_lineGraphic.symbol=_lineSymbol;
			}
		}
		
		/**绑定的graphicLayer**/
		private var _graphcisLayer:GraphicsLayer;
		public function get graphcisLayer():GraphicsLayer
		{
			return _graphcisLayer;
		}
		
		public function set graphcisLayer(value:GraphicsLayer):void
		{
			_graphcisLayer=value;
		}
		
		/**测量线**/
		private var _lineGraphic:Graphic=null;
		
		/**起点**/
		private var _startPoint:Graphic=null;
		
		/**结果**/
		private var _resultGraphic:Graphic=null;
		
		/**组成该条线段的所有Graphic**/
		private var _graphics:Array=[];
		
		/**终点的符号样式**/
		private var _endSymbol:MarkerSymbol;
		public function get endSymbol():MarkerSymbol
		{
			return _endSymbol;
		}
		
		public function set endSymbol(value:MarkerSymbol):void
		{
			_endSymbol=value;
		}
		
		/**删除按钮**/
		private var _deleteGraphic:Graphic=null;
		private var deleteGraphicName:String = "deleteGraphic";
		
		/**起点的符号样式**/
		private var _startSymbol:MarkerSymbol;
		public function get startSymbol():MarkerSymbol
		{
			return _startSymbol;
		}
		public function set startSymbol(value:MarkerSymbol):void
		{
			_startSymbol=value;
		}
		
		/**测量是否完成**/
		private var _compelete:Boolean=false;
		public function get compeleted():Boolean
		{
			return _compelete;
		}
		public function set compeleted(value:Boolean):void
		{
			_compelete=value;
		}
		
		private var _config:XML;
		
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
		
		private var _scale:Number;
		
		/**
		 * 编辑工具
		 **/
		private var _editTool:EditTool;
		
		private var _srtype:String;
		
		public function PolylineElement(config:XML)
		{
			_config=config.polylineElement[0];
			
			//创建startSymbol
			_startSymbol=new PictureMarkerSymbol(String(_config.startPoint.symbol.@source));
			_startSymbol.xoffset=Number(_config.startPoint.symbol.@xoffset);
			_startSymbol.yoffset=Number(_config.startPoint.symbol.@yoffset);
			
			//创建endSymbol
			_endSymbol=new PictureMarkerSymbol(String(_config.endPoint.symbol.@source));
			_endSymbol.xoffset=Number(_config.endPoint.symbol.@xoffset);
			_endSymbol.yoffset=Number(_config.startPoint.symbol.@yoffset);
			
			//创建vertex
			_markerSymbol=new SimpleMarkerSymbol("circle");
			_markerSymbol.color=uint(_config.vertex.symbol.@color)||0xff0000;
			_markerSymbol.size=Number(_config.vertex.symbol.@size)||10;
			var border:SimpleLineSymbol=new SimpleLineSymbol();
			border.color=uint(_config.vertex.symbol.@borderColor)||0xff0000;
			border.width=Number(_config.vertex.symbol.@borderSize)||1.5;
			_markerSymbol.outline=border;
			
			//创建清除按钮
			var markerSym:PictureMarkerSymbol=new PictureMarkerSymbol(String(_config.deleteButton.symbol.@source));
			markerSym.xoffset=Number(String(_config.deleteButton.symbol.@xoffset));
			markerSym.yoffset=Number(String(_config.deleteButton.symbol.@yoffset));
			_deleteGraphic=new Graphic(null,markerSym,{element:this});
			_deleteGraphic.id = deleteGraphicName;
			_deleteGraphic.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
			{
				clean();
			});
			_deleteGraphic.toolTip=_config.deleteButton.symbol.@tooltip;
			_deleteGraphic.buttonMode=true;
			
			_lineGraphic=new Graphic(null,_lineSymbol);
			
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
		public function clean():void
		{
			removeEditEvent();
			_editTool.deactivate();
			_graphcisLayer.map.removeEventListener(MouseEvent.CLICK,map_clickHandler);
			_graphcisLayer.clear();
		}
		
		/**
		 * 设置起点，提供给LineMeasureControl对象使用
		 **/
		public function setStartPoint(pt:MapPoint):void
		{
			var comSymbol:CompositeSymbol=createCompositeSymbol(_startSymbol,uint(_config.startPoint.displayLabel.@color),
				String(_config.startPoint.displayLabel.@text),
				int(_config.startPoint.displayLabel.@xoffset),
				int(_config.startPoint.displayLabel.@yoffset),
				uint(_config.startPoint.displayLabel.@backgroundColor),
				uint(_config.startPoint.displayLabel.@borderColor));
			_startPoint=new Graphic(pt,comSymbol);
			_graphcisLayer.add(_lineGraphic);
			_graphcisLayer.add(_startPoint);
			_graphics.push(_startPoint);
			_graphics.push(_lineGraphic);
			
		}
		
		/**
		 * 设置测量时的部分结果，提供给LineMeasureControl对象使用
		 **/
		public function setPartResult(pt:MapPoint,length:Number,line:Polyline=null):void
		{
			if(compeleted)
			{
				var polyline:Polyline =line;
				_lineGraphic.geometry=polyline;
				_lineGraphic.refresh();
				createCompeleteGraphics(pt,length);
			}
			else
			{
				createVertexResutl(pt,length);
			}
		}
		
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
		
		/**
		 * 创建复合symbole
		 **/
		private function createCompositeSymbol(markerSymbol:MarkerSymbol,color:uint,text:String,xoffset:int,yoffset:int,backgroundColor:uint,borderColor:uint):CompositeSymbol
		{
			var comSymbol:CompositeSymbol=new CompositeSymbol();
			var txtSymbol:TextSymbol=new TextSymbol();
			txtSymbol.text=text;
			txtSymbol.color=color;
			txtSymbol.background=true;
			txtSymbol.backgroundColor=backgroundColor;
			txtSymbol.border=true;
			txtSymbol.borderColor=borderColor;
			txtSymbol.xoffset=xoffset;
			txtSymbol.yoffset=yoffset;
			var symbols:ArrayCollection=new ArrayCollection([markerSymbol,txtSymbol]);
			comSymbol.symbols=symbols;
			
			return comSymbol;
		}
		
		private function createCompeleteGraphics(pt:MapPoint,length:Number):void
		{
			//创建结果展示
			_resultGraphic=new Graphic();
			createEndVertex(pt,length);
			bindEditEvent();
			_editTool=new EditTool(_graphcisLayer.map);
			_editTool.addEventListener(EditEvent.GEOMETRY_UPDATE,geometry_updateHandler);
			
		}
		
		private function map_clickHandler(event:MouseEvent):void
		{
			removeEditEvent();
			_editTool.deactivate();
			_graphcisLayer.map.removeEventListener(MouseEvent.CLICK,map_clickHandler);
			bindEditEvent();
		}
		
		private function lineGraphic_clickHandler(event:MouseEvent):void
		{
			removeEditEvent();
			
			_graphcisLayer.map.addEventListener(MouseEvent.CLICK,map_clickHandler);
			
			_editTool.activate(EditTool.EDIT_VERTICES,[_lineGraphic]);
			event.stopPropagation();
		}
		
		private function geometry_updateHandler(event:EditEvent):void
		{
			//更新计算结果
			var g:Graphic = _graphics.pop();
			while(g!=null)
			{
				if(g!=_lineGraphic)
				{
					_graphcisLayer.remove(g);
					
				}
				g= _graphics.pop();
			}
			_graphics.push(_lineGraphic);
			var polyline:Polyline=	_lineGraphic.geometry as Polyline;
			var part:Array=	polyline.paths[0];
			var partPtLength:int=part.length;
			var partLine:Polyline=new Polyline(null,_graphcisLayer.spatialReference);
			partLine.paths=new Array();
			partLine.paths.push(new Array());
			
			var results:Array = [];
			for(var i:int=0;i<partPtLength;i++)
			{
				partLine.insertPoint(0,i,part[i]);
				if(i==0)
				{
					//起点
					_startPoint.geometry=part[i];
					_graphcisLayer.add(_startPoint);
					_graphics.push(_startPoint);
					continue;
				}
				if(_srtype == "project")
				{
					//平面坐标计算
					results = [projectLengths(partLine)]
				}
				else
				{
					//地理坐标计算
					results= GeometryUtil.geodesicLengths([partLine],com.esri.ags.Units.METERS);
				}
				if(i==partPtLength-1)
				{
					
					//终点
					createEndVertex(part[i],results[0]);
				}
				else
				{
					createVertexResutl(part[i],results[0]);
				}
			}
		}
		
		/**
		 * 创建线段的节点的显示
		 **/
		private function createVertexResutl(pt:MapPoint,result:Number):void
		{
			var text:String=_config.vertex.displayLabel.@text;
			text=replaceLengthAndUnit(text,result);
			var csym:CompositeSymbol=createCompositeSymbol(_markerSymbol,uint(_config.vertex.displayLabel.@color),
				text,
				int(_config.vertex.displayLabel.@xoffset),
				int(_config.vertex.displayLabel.@yoffset),
				uint(_config.vertex.displayLabel.@backgroundColor),
				uint(_config.vertex.displayLabel.@borderColor));
			var ptg:Graphic = new Graphic(pt,csym);
			_graphcisLayer.add(ptg);
			_graphics.push(ptg);
		}
		
		/**
		 * 创建线段的终点显示，包括删除按钮
		 **/
		private function createEndVertex(pt:MapPoint,result:Number):void
		{
			//结果显示Graphic
			_resultGraphic.geometry=pt;
			var text:String=_config.endPoint.displayLabel.@text;
			text=replaceLengthAndUnit(text,result);
			var comsym:CompositeSymbol=createCompositeSymbol(_endSymbol,uint(_config.endPoint.displayLabel.@color),
				text,
				int(_config.endPoint.displayLabel.@xoffset),
				int(_config.endPoint.displayLabel.@yoffset),
				uint(_config.endPoint.displayLabel.@backgroundColor),
				uint(_config.endPoint.displayLabel.@borderColor));
			_resultGraphic.symbol=comsym;
			_graphcisLayer.add(_resultGraphic);
			_graphics.push(_resultGraphic);
			
			//创建清除按钮
			_deleteGraphic.geometry=pt;
			_graphcisLayer.add(_deleteGraphic);
			_graphics.push(_deleteGraphic);
		}
		
		/**
		 * 给除了删除graphic外的其他全部graphic都绑定上编辑触发事件
		 **/
		private function bindEditEvent():void
		{
			var length:int=_graphics.length;
			for(var i:int=0;i<length;i++)
			{
				var g:Graphic=_graphics[i];
				if(g.id!=deleteGraphicName){
					g.addEventListener(MouseEvent.CLICK,lineGraphic_clickHandler);
				}
			}
		}
		/**
		 * 给除了删除graphic外的其他全部graphic都解除编辑触发事件
		 **/
		private function removeEditEvent():void
		{
			var length:int=_graphics.length;
			for(var i:int=0;i<length;i++)
			{
				var g:Graphic=_graphics[i];
				if(g.id!=deleteGraphicName){
					g.removeEventListener(MouseEvent.CLICK,lineGraphic_clickHandler);
				}
			}
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
	}
}