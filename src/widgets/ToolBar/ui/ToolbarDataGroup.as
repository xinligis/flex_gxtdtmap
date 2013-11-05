package widgets.ToolBar.ui
{
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.graphics.SolidColor;
	
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.primitives.Rect;
	
	[Event(name="ToolActive",type="flash.events.Event")]
	[Event(name="ToolDeactive",type="flash.events.Event")]
	[Event(name="CommandExcute",type="flash.events.Event")]
	[Event(name="RunWidgetCommand",type="widgets.ToolBar.RunWidegtEvent")]
	[Event(name="ExcuteEvent",type="widgets.ToolBar.ExcuteEvent")]
	[Event(name="SendPostProcess",type="widgets.ToolBar.PostProcessEvent")]
	[Event(name="toolCommandLoadCompelete",type="flash.events.Event")]
	public class ToolbarDataGroup extends DataGroup
	{
		private var _bgGroup:Group;
		public function ToolbarDataGroup()
		{
			super();
			
			this.itemRendererFunction=rendererFunction;
//			this.addEventListener(MouseEvent.MOUSE_MOVE,function(evnet:MouseEvent):void
//			{
//				trace("MouseEvent.MOUSE_MOVE");
//			});
		}
		
		private function rendererFunction(item:Object):ClassFactory
		{
			if (item.isGroup)
			{
				return new ClassFactory(ToolBarItemGroupRanderer);
			}
			else
			{
				return new ClassFactory(ToolBarItemRanderer);
			}
		}
	}
}