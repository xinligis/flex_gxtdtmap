package widgets.ToolBar.Tools.Marker
{
	import com.esri.ags.Graphic;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.events.GraphicsLayerEvent;
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.tools.DrawTool;
	import com.esri.ags.utils.JSON;
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.BaseWidget;
	import com.esri.viewer.ConfigData;
	import com.esri.viewer.IInfowindowTemplate;
	import com.esri.viewer.components.tools.AES;
	import com.esri.viewer.utils.UrlConstructor;
	import com.esrichina.om.componet.ResizeDragContainer;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.codec.PNGEncoder;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.VGroup;
	import spark.primitives.Rect;
	
	import widgets.InfoTemplates.MarkerInfoWidget;
	import widgets.ToolBar.Tools.BaseTool;
	import widgets.ToolBar.Tools.Screenshot.skin.PrintButtonSkin;
	import widgets.ToolBar.Tools.Screenshot.skin.SaveButtonSkin;
	
	/**
	 * 地图标记工具
	 * @author 温杨彪
	 **/
	public class MarkerTool extends BaseTool
	{
		private var _drawTool:DrawTool=new DrawTool();
		private var _markerSymbol:PictureMarkerSymbol;
		
		private var _widgetId:Number = 20120420;
		private var _hostUrl:String = "";
		
		public function MarkerTool()
		{
			super();
		}
		public override function set configXML(value:XML):void
		{
			super.configXML=value;
			_markerSymbol = new PictureMarkerSymbol
				(String(configXML.markersymbol.@url),Number(configXML.markersymbol.@width)
					,Number(configXML.markersymbol.@height),Number(configXML.markersymbol.@xoffset),
					Number(configXML.markersymbol.@yoffset));
			_hostUrl = String(configXML.hosturl);
			_hostUrl = UrlConstructor.getUrl(_hostUrl);
			_drawTool.map=map;
			_drawTool.addEventListener(DrawEvent.DRAW_END,draw_endHandler);
			
			var infoUrl:String = configXML.info;
			var data:Object =
				{
					id: String(_widgetId),
					url: infoUrl,
					config: ""
				};
			AppEvent.dispatch(AppEvent.DATA_CREATE_INFOWIDGET, data, infoReady);
		}
		
		private var infoTemplate:IInfowindowTemplate;
		
		private function infoReady(event:AppEvent):void
		{
			var id:Number = Number(event.data.id);
			if (id == _widgetId)
			{
				infoTemplate = event.data.infoWidget;
				infoTemplate.infoConfig = configXML;
			}
			
			//如果在url中有相关的展示标记的信息，那么需要展示出来
			if(configData.urlParam.hasOwnProperty("operation"))
			{
				if(configData.urlParam.operation == "marker")
				{
					showMarker();
				}
			}
		}
		
		private function layer_updateEndHandler(event:LayerEvent):void
		{
			Alert.show("L140");
			event.layer.removeEventListener(LayerEvent.UPDATE_END,layer_updateEndHandler);
			showMarker();
		}
		
		/**
		 * 显示标注。
		 * @author 温杨彪
		 * @date 2012-11-29
		 **/
		private function showMarker():void
		{
			var pwData:String = configData.urlParam.data;
			pwData = AES.decrypt(pwData,"com.esrichina.onemap",AES.BIT_KEY_128);
			var jsonData:Object = com.esri.ags.utils.JSON.decode(pwData);
			//当前地图组，王红亮，2013-3-11
			AppEvent.dispatch(AppEvent.BASEMAP_SWITCH, jsonData.mapgroup);
			var extent:Extent = new Extent(Number(jsonData.xmin),Number(jsonData.ymin),
				Number(jsonData.xmax),Number(jsonData.ymax));
			var pt:MapPoint = new MapPoint(Number(jsonData.x),Number(jsonData.y));
			var attr:Object = new Object();
			attr.markername = jsonData.markername;
			attr.markerdetail = jsonData.markerdetail;
			attr.hostUrl = _hostUrl;
			var g:Graphic = new Graphic(pt,_markerSymbol,attr);
			g.buttonMode = true;
			g.addEventListener(MouseEvent.CLICK,marker_clickHandler);
			graphicsLayer.map.extent = extent;
			graphicsLayer.add(g);
			showInfoWindow(g);
		}
		
		private function draw_endHandler(event:DrawEvent):void
		{
			var g:Graphic = event.graphic;
			g.attributes = new Object();
			g.attributes.hostUrl = _hostUrl;
			g.symbol = _markerSymbol;
			g.buttonMode = true;
			g.addEventListener(MouseEvent.CLICK,marker_clickHandler);
			graphicsLayer.add(g);
			_drawTool.deactivate();
			showInfoWindow(g);
			deactivate();
		}
		
		public override function set graphicsLayer(value:GraphicsLayer):void
		{
			super.graphicsLayer = value;
			graphicsLayer.addEventListener(GraphicsLayerEvent.GRAPHICS_CLEAR,function(event:GraphicsLayerEvent):void
			{
				map.infoWindow.hide();
			});
		}
		
		private function marker_clickHandler(event:MouseEvent):void
		{
			var g:Graphic = event.currentTarget as Graphic;
			showInfoWindow(g);
		}
		
		public override function activate(params:Object=null):void
		{
			super.activate(params);
			//画框
			_drawTool.activate(DrawTool.MAPPOINT);
		}
		
		private function showInfoWindow(graphic:Graphic):void
		{
			if (graphic)
			{
				//map.infoWindow.width = 320;
				
				//王红亮，2011-04-08
//				var infoWindowData:Object = {};
				
				//温杨彪；2011-7-29   让infoWindow第一次能显示东西
				infoTemplate.data = {graphic:graphic,graphicsLayer:graphicsLayer};
				map.infoWindow.content = infoTemplate as UIComponent;
				map.infoWindow.label = "";
				map.infoWindow.show(getGeomCenter(graphic));
			}
			else
			{
				map.infoWindow.hide();
			}
		}
		
		//get geom center
		private function getGeomCenter(graphic:Graphic):MapPoint
		{
			var pt:MapPoint;
			switch (graphic.geometry.type)
			{
				case Geometry.MAPPOINT:
				{
					pt = graphic.geometry as MapPoint;
					break;
				}
			}
			return pt;
		}
		
	}
}