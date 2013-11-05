package com.esri.viewer.components.pageSelector
{
	import flash.events.Event;
	
	public class PageChangeEvent extends Event
	{
		public function PageChangeEvent(type:String = "PageChanged", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * 当前页序号，基数为0
		 */
		public var currentPage:int = -1;
	}
}