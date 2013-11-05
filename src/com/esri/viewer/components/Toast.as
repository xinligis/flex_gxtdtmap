package com.esri.viewer.components
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	import mx.graphics.SolidColor;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.effects.Fade;
	import spark.primitives.Rect;
	
	/**
	 * 一段时间后自己消失的信息框，单件模式类，不能实例化
	 **/
	public class Toast extends Group
	{
		//使用单件模式
		private static var _instance:Toast = null;
		
		private var _fadeInnOut:Sequence;
		private var _showFade:Fade = null;
		private var _hideFade:Fade = null;
		private var _toastText:Label = null;
		
		public function Toast(obj:ProtectedClass)
		{
			super();
			
			//			this.minWidth = 100;
			
			_fadeInnOut = new Sequence(this);
			_showFade = new Fade();
			_showFade.duration = 1000;
			_showFade.alphaFrom = 0;
			_showFade.alphaTo = 1;
			
			_hideFade = new Fade();
			_hideFade.duration = 1500;
			_hideFade.alphaFrom = 1;
			_hideFade.alphaTo = 0;
			_fadeInnOut.addChild(_showFade);
			_fadeInnOut.addChild(_hideFade);
			
			_fadeInnOut.addEventListener(EffectEvent.EFFECT_END,fadeInnOut_effectEndHandler);
			
			var rect:Rect = new Rect();
			rect.radiusX = 10;
			rect.radiusY = 10;
			rect.percentWidth = 100;
			rect.height = 50;
			rect.fill = new SolidColor(0x000000);
			this.addElement(rect);
			
			_toastText = new Label();
			_toastText.verticalCenter = 0;
			_toastText.horizontalCenter = 0;
			_toastText.left = 20;
			_toastText.right = 20;
			_toastText.setStyle("color",0xffffff);
			_toastText.setStyle("fontWeight","bold");
			_toastText.setStyle("fontFamily","宋体");
			this.addElement(_toastText);
		}
		
		private function showToast(toastText:String, parent:DisplayObject = null):void
		{
			_toastText.text = toastText;
			if(_fadeInnOut.isPlaying)
			{
				_fadeInnOut.end();
			}
			if(!parent)
			{
				parent = FlexGlobals.topLevelApplication as DisplayObject;
			}
			PopUpManager.addPopUp(this as IFlexDisplayObject, parent,false);
			PopUpManager.centerPopUp(this);
			_fadeInnOut.play();
		}
		
		private function fadeInnOut_effectEndHandler(event:EffectEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		private static function getInstance():Toast
		{
			if(_instance == null)
			{
				_instance = new Toast(new ProtectedClass());
			}
			return _instance;
		}
		
		/**
		 * 显示信息
		 * @param message 显示在窗口上的文字提示信息
		 * @param parent 父窗口，默认为顶级的应用程序窗口
		 **/
		public static function show(message:String, parent:DisplayObject = null):void
		{
			getInstance().showToast(message, parent);
		}
		
		/**
		 * 设置显示时间，单位：毫秒
		 **/
		public static function setShowTime(time:int):void
		{
			if(time <1000)
			{
				time = 1000;
			}
			getInstance()._hideFade.duration = time - 1000;
		}
	}
}
class ProtectedClass
{
	public function ProtectedClass()
	{
		
	}
}