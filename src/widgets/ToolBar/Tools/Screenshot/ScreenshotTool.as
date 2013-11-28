package widgets.ToolBar.Tools.Screenshot
{
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.tools.DrawTool;
	import com.esrichina.om.componet.ResizeDragContainer;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
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
	
	import widgets.ToolBar.Tools.BaseTool;
	import widgets.ToolBar.Tools.Screenshot.skin.PrintButtonSkin;
	import widgets.ToolBar.Tools.Screenshot.skin.SaveButtonSkin;
	
	/**
	 * 截图，保存图片
	 * @author 温杨彪
	 **/
	public class ScreenshotTool extends BaseTool
	{
		private var _drawTool:DrawTool=new DrawTool();
		
		private var _ssExtent:ResizeDragContainer=null;
		private var _submitButton:Button;
		private var _cancelButton:Group;
		private var _vgroup:VGroup;
		private var _printButton:Button;
		public function ScreenshotTool()
		{
			super();
			//runWidgetHandler = 
		}
		public override function set configXML(value:XML):void
		{
			super.configXML=value;
			_drawTool.map=map;
			_drawTool.addEventListener(DrawEvent.DRAW_END,draw_endHandler);
			
			//创建默认polygon
			var outLineSym:SimpleLineSymbol=new SimpleLineSymbol("solid",0xda0000,1,2);
			var polygonSymbol:SimpleFillSymbol = new SimpleFillSymbol("solid",0xCCCCCC,0.5,outLineSym);
			_drawTool.fillSymbol = polygonSymbol;
			
			createButtons();
		}
		
		//创建保存、打印、取消按钮
		private function createButtons():void
		{
			//取消按钮
			_cancelButton=new Group();
			_cancelButton.width=20;
			_cancelButton.height=20;
			
			var img:Image=new Image();
			img.source="assets/images/snapshot/w_close_red.png";
			_cancelButton.addElement(img);
			_cancelButton.toolTip="点击取消";
			_cancelButton.buttonMode=true;
			_cancelButton.top=-10;
			_cancelButton.right=-10;
			_cancelButton.addEventListener(MouseEvent.CLICK,function(event:Event):void
			{
				deactivate();
			});
			
			//保存按钮
			_submitButton=new Button();
			_submitButton.setStyle("skinClass",widgets.ToolBar.Tools.Screenshot.skin.SaveButtonSkin);
			_submitButton.label="保 存";
			_submitButton.width=80;
			_submitButton.height=40;
			_submitButton.addEventListener(MouseEvent.CLICK,submit_clickHandler);
			
			//打印按钮
			_printButton=new Button();
			_printButton.label="打印";
			_printButton.setStyle("skinClass",widgets.ToolBar.Tools.Screenshot.skin.PrintButtonSkin);
			_printButton.width=80;
			_printButton.height=40;
			_printButton.addEventListener(MouseEvent.CLICK,print_clickHandler);
			
			var hgroup:HGroup=new HGroup();
			hgroup.gap=20;
			hgroup.addElement(_submitButton);
			hgroup.addElement(_printButton);
			
			
			_vgroup=new VGroup();
			_vgroup.addElement(hgroup);
//			_vgroup.addElement(_printButton);
			_vgroup.verticalCenter=0;
			_vgroup.horizontalCenter=0;
		}
		
		private function print_clickHandler(event:MouseEvent):void
		{
			var bmp:BitmapData=snapshot();
			deactivate();
			//runWidgetHandler.call(
			if(runWidgetHandler!=null)
			{
				runWidgetHandler.call(null,this,"widgets/Print/PrintWidget.swf",bmp,runcallback);
			}
//			if(activeOtherToolorCommandHandler!=null)
//			{
//				activeOtherToolorCommandHandler.call(null,"widgets.ToolBar.Tools.Print.PrintTool",bmp);
//			}
		}
		
		private function runcallback():void
		{
			trace("runcallback");
		}
		
		
		private function submit_clickHandler(event:MouseEvent):void
		{
			var retBitmapData:BitmapData=snapshot();
			var fileReference:FileReference=new FileReference();
			var pngEnc:PNGEncoder = new PNGEncoder();
			fileReference.save(pngEnc.encode(retBitmapData),"snapshot.png");
			deactivate();
		}
		
		private function draw_endHandler(event:DrawEvent):void
		{
			_drawTool.deactivate();
			var geoExtent:Extent=event.graphic.geometry as Extent;
			_ssExtent=new ResizeDragContainer(map);
			var LBpt:Point=map.toScreen(new MapPoint(geoExtent.xmin,geoExtent.ymin,map.spatialReference));
			var RUpt:Point=map.toScreen(new MapPoint(geoExtent.xmax,geoExtent.ymax));
			_ssExtent.x=LBpt.x;
			_ssExtent.y=RUpt.y;
			_ssExtent.width=RUpt.x-LBpt.x;
			_ssExtent.height=LBpt.y-RUpt.y;
			_ssExtent.resizable=true;
			_ssExtent.draggable=true;
			var rect:Rect=new Rect();
			rect.top=0;
			rect.bottom=0;
			rect.left=0;
			rect.right=0;
			rect.stroke=new SolidColorStroke(0xda0000,2);
			rect.fill=new SolidColor(0xCCCCCC,0.5);
			_ssExtent.addElement(rect);
			_ssExtent.addElement(_vgroup);
			_ssExtent.addElement(_cancelButton);
			map.addChild(_ssExtent);
		}
		
		public override function deactivate(params:Object=null):void
		{
			super.deactivate(params);
			_drawTool.deactivate();
			if(_ssExtent!=null)
			{
				_ssExtent.removeElement(_vgroup);
				map.removeChild(_ssExtent);
				_ssExtent=null;
			}
		}
		
		public override function activate(params:Object=null):void
		{
			super.activate(params);
			//画框
			_drawTool.activate(DrawTool.EXTENT);
		}
		
		private function snapshot():BitmapData
		{
			_ssExtent.removeElement(_vgroup);
			map.removeChild(_ssExtent);
			var rect:Rectangle=new Rectangle(_ssExtent.x,_ssExtent.y,_ssExtent.width,_ssExtent.height);
			_ssExtent=null;
			var bmp:BitmapData =ImageSnapshot.captureBitmapData(map,null,null,null,null,true);
			var retBitmapData:BitmapData = new BitmapData(rect.width,rect.height);
			retBitmapData.copyPixels(bmp,rect,new Point(0,0));
			return retBitmapData;
		}
	}
}