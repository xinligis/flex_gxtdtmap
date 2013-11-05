package widgets.TabbedWidgetContainer.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	import spark.components.ButtonBarButton;
	import spark.components.Image;
	[Event (name="closeTab", type="flash.events.Event")]
	public class ClosableTab extends ButtonBarButton
	{
		// Our private variable to track the rollover state
		private var _rolledOver:Boolean = false;
		[SkinPart (required="false")] 
		public var iconImage:Image;
		[SkinPart (required="false")]
		public var closeButton:Button;
		public function ClosableTab()
		{
			super();
			
			// We need to enabled mouseChildren so our closeButton can receive
			// mouse events.
			this.mouseChildren = true;
			this.doubleClickEnabled = false;
		}
	
	
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true); 
			}
//			else if(instance == iconImage)
//			{
//				iconImage.source = "assets/images/mainwidgets/close.png";
//			}
		}
	
		override public function set enabled(value:Boolean):void {
			super.enabled = value;
			
			if(closeButton) {
				closeButton.enabled = value;
			}
		}

		
		/**
		 * The click handler for the close button.
		 * This makes the SuperTab dispatch a CLOSE_TAB_EVENT. This doesn't actually remove
		 * the tab. We don't want to remove the tab itself because that will happen
		 * when the SuperTabNavigator or SuperTabBar removes the child container. So within the SuperTab
		 * all we need to do is announce that a CLOSE_TAB_EVENT has happened, and we leave
		 * it up to someone else to ensure that the tab is actually removed.
		 */
		private function closeClickHandler(event:MouseEvent):void {
			if(this.enabled) 
			{
				dispatchEvent(new Event("closeTab"));
			}
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		override public function set selected(value:Boolean):void {
			
			super.selected = value;
			
			callLater(invalidateSize);
		}
		
	}
}