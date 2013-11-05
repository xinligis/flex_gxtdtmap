package widgets.Print.element
{
	import mx.core.UIComponent;
	
	import spark.components.Image;
	

	public class CompassElement extends Element
	{
		private var _img:Image;
		
		public function CompassElement(printContent:UIComponent)
		{
			super(printContent);
			_img=new Image();
			
			_img.setStyle("backgroudAlpha","0");
			_img.scaleMode="letterbox";
			_img.top=0;
			_img.bottom=0;
			_img.right=0;
			_img.left=0;
			this.draggable=true;
			this.resizable=true;
			this.deleteable=true;
			this.addElement(_img);
		}
		
		public function set source(value:Object):void
		{
			_img.source=value;
		}
		
		public function get source():Object
		{
			return _img.source;
		}
	}
}