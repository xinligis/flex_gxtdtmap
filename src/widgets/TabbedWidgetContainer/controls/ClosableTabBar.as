package widgets.TabbedWidgetContainer.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.core.IVisualElement;
	
	import spark.components.IItemRenderer;
	import spark.components.TabBar;
	import spark.events.RendererExistenceEvent;
	
	import widgets.TabbedWidgetContainer.events.ClosableTabEvent;

	[Event(name="tabClose", type="widgets.TabbedWidgetContainer.events.ClosableTabEvent")]
	public class ClosableTabBar extends TabBar
	{
		public function ClosableTabBar()
		{
			super();
		}

		/**
		 *  @private
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			const renderer:IVisualElement = event.renderer; 
			if (renderer)
			{
				renderer.addEventListener("closeTab", item_closeTabHandler);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{   
			super.dataGroup_rendererRemoveHandler(event);
			
			const renderer:IVisualElement = event.renderer;
			if (renderer)
				renderer.removeEventListener("closeTab", item_closeTabHandler);
		}
		
		public function item_closeTabHandler(event:Event):void
		{
			var newIndex:int;
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			if(newIndex < 0)
			{
				return;
			}
			this.dispatchEvent(new ClosableTabEvent(ClosableTabEvent.TAB_CLOSE, newIndex));
			//dataProvider.removeItemAt(newIndex);
		}
	}
}