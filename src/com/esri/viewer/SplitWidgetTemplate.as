///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010-2011 Esri中国. All Rights Reserved.
//用于拆分widgetContainer中的widget模板
//王红亮，2012-01-06
///////////////////////////////////////////////////////////////////////////
package com.esri.viewer
{
	import com.esri.viewer.WidgetStates;
	
	import flash.events.Event;
	
	import spark.components.SkinnableContainer;
	[Event(name = "open", type = "flash.events.Event")]
	[Event(name = "closed", type = "flash.events.Event")]
	public class SplitWidgetTemplate extends SkinnableContainer implements IWidgetTemplate
	{
		private static const WIDGET_OPENED:String = "open";
		private var _widgetId:Number;
		private var _widgetState:String = WIDGET_OPENED;
		private var _widgetTitle:String = "";
		private var _widgetIcon:Class;
		[Bindable]
		private var _draggable:Boolean = true;
		private var _resizable:Boolean = true;
		private var _baseWidget:IBaseWidget;
		public function SplitWidgetTemplate()
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.setStyle("fontFamily", "宋体");
		}
		
		public function set baseWidget(value:IBaseWidget):void
		{
			_baseWidget = value;
			this.resizable = value.isResizeable;
			this.draggable = value.isDraggable;
			this.widgetId = value.widgetId;
			this.widgetTitle = value.widgetTitle;

		}
		public function get baseWidget():IBaseWidget
		{
			return _baseWidget;
		}
	
		public function set draggable(value:Boolean):void
		{
		}
		
		public function set resizable(value:Boolean):void
		{
			_resizable = value;
		}
		
		[Bindable]
		public function get resizable():Boolean
		{
			return _resizable;
		}
		
		public function get widgetId():Number
		{
			return _widgetId;
		}
		
		public function set widgetId(value:Number):void
		{
			_widgetId = value;
		}
		
		[Bindable]
		public function get widgetTitle():String
		{
			return _widgetTitle;
		}
		
		public function set widgetTitle(value:String):void
		{
			_widgetTitle = value;
		}
		
		[Bindable]
		public function get widgetIcon():Class
		{
			return this._widgetIcon;
		}
		
		public function set widgetIcon(value:Class):void
		{
			this._widgetIcon = value;
		}
		
		public function set widgetState(value:String):void
		{

			_widgetState = value;		
			dispatchEvent(new Event(_widgetState));

		}
		
		public function get widgetState():String
		{
			return _widgetState;
		}
	}
}