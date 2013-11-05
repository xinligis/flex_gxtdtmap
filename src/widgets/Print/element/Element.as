package widgets.Print.element
{
	import com.esrichina.om.componet.ResizeDragContainer;
	
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Group;

	public class Element extends ResizeDragContainer implements IElement
	{
		public static const TEXT_TYPE:String="text";
		
		private var _name:String;
		private var _type:String; 
		
		
		public function Element(printContent:UIComponent)
		{
			
			super(printContent);
			
//			this.addEventListener(MouseEvent.MOUSE_DOWN,group_mouseDownHandler);
		}
		
		
		public override function get name():String
		{
			return _name;
		}
		
		public override function set name(value:String):void
		{
			_name=value;
		}
		
		public function set type(value:String):void
		{
			_type=value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
		public function centerForHorizontal():void
		{
			var parentWidth:Number=this.parent.width;
			this.x=parentWidth/2-this.width/2;
		}
		
		public function centerForVertical():void
		{
			var parentHeight:Number=this.parent.height;
			this.y=parentHeight/2-this.height/2;
		}
		
		public function center():void
		{
			centerForHorizontal();
			centerForVertical();
		}
	}
}