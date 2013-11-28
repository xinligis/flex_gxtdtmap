package widgets.Print.element
{
	import com.esri.ags.Map;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.SolidColorStroke;
	
	import spark.primitives.Rect;

	public class MapElement extends Element
	{
		private var _mapImg:Image;
		
		private var _borderRect:Rect;
		
		private var _borderStroke:SolidColorStroke;
		
		public function MapElement(printContent:UIComponent,bmpData:BitmapData=null,width:int=750,height:int=500)
		{
			super(printContent);
			
			this.width=width;
			this.height=height;
			this.draggable=true;
			//设置边框
			_borderStroke = new SolidColorStroke();
			_borderStroke.color=0x000000;
			_borderStroke.weight=1;
			_borderRect=new Rect();
//			_borderRect.top=-5;
//			_borderRect.bottom=-5;
//			_borderRect.left=-5;
//			_borderRect.right=-5;
			
			_borderRect.top=_borderStroke.weight*(-1);
			_borderRect.bottom=_borderStroke.weight*(-1);
			_borderRect.left=_borderStroke.weight*(-1);
			_borderRect.right=_borderStroke.weight*(-1);
			
			_borderRect.stroke=_borderStroke;
			this.addElement(_borderRect);
			
			//设置地图图片
			_mapImg=new Image();
			_mapImg.smoothBitmapContent=true;
			_mapImg.percentWidth=100;
			_mapImg.percentHeight=100;
			_mapImg.scaleContent=true;
			if(bmpData!=null)
			{
				setDataSource(bmpData);
			}
			
			this.addElement(_mapImg);
		}
		
		
		public function createMap(map:Map):void
		{
			if(_mapImg.source!=null)
			{
				centerForHorizontal();
				centerForVertical();
				return;
			}
			map.scaleBarVisible=false;
//			map.logoVisible=false;
			setTimeout(function():void
			{
				var bmp:BitmapData =ImageSnapshot.captureBitmapData(map,null,null,null,null,true);
				setDataSource(bmp);
				centerForHorizontal();
				centerForVertical();
				
				map.scaleBarVisible=true;
				
			},300);
		}
		
		public function zoomIn():void
		{
			var tmpW:Number=width;
			
			width=width-10;
			height=height-(height*10/tmpW);
		}
		
		public function zoomOut():void
		{
			var tmpW:Number=width;
			
			width=width+10;
			height=height+(height*10/tmpW);
			if((this.x + width)>this.parent.width){
				width = this.parent.width - x;
				height=height-(height*10/tmpW);
			}
			if((this.y + height) >this.parent.height){
				width=width-10;
				height = this.parent.height - y;
			}
		}
		
		[Bindable]
		public function get borderWidth():int
		{
			return _borderStroke.weight;
		}
		public function set borderWidth(value:int):void
		{
			if(value==0)
			{
				_borderStroke.alpha=0;
				_borderStroke.weight=value;
				return;
			}
			else if(value<0)
			{
				return;
			}
			_borderStroke.alpha=1;
			_borderStroke.weight=value;
			
			//2012-04-23；设置地图轮廓时，让轮廓自动往外面扩；温杨彪
			_borderRect.top=_borderStroke.weight*(-1);
			_borderRect.bottom=_borderStroke.weight*(-1);
			_borderRect.left=_borderStroke.weight*(-1);
			_borderRect.right=_borderStroke.weight*(-1);
		}
		
		[Bindable]
		public function get borderColor():uint
		{
			return _borderStroke.color;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderStroke.color=value;
		}
		
		private function setDataSource(bmp:BitmapData):void
		{
			if(bmp == null)
				return;
			_mapImg.source=new Bitmap(bmp,"auto",true);
			//宽>长
			if(bmp.width>bmp.height)
			{
				if(bmp.width<this.width)
				{
					this.width=bmp.width;
					this.height=bmp.height;
				}
				else
				{
					this.height=this.width*bmp.height/bmp.width;
				}
			}
			//宽<长
			else 
			{
				if(bmp.height<this.height)
				{
					this.height=bmp.height;
					this.width=bmp.width;
				}
				else
				{
					this.width=this.height*bmp.width/bmp.height;
				}
			}
		}
		
		
	}
}