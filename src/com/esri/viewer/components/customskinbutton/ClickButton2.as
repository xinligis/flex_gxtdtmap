
package com.esri.viewer.components.customskinbutton
{
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	
	[Style(name="normalImage", inherit="no", type="Class")]
	[Style(name="overImage", inherit="no", type="Class")]
	/**
	 * 按钮样式。有5种类型。
	 * <p>
	 * <b>circleRadius</b>：圆角类型。
	 * <p>
	 * <b>normalTowState</b>：普通的拥有两种状态的类型。
	 * <p>
	 * <b>normalThreeState</b>：普通的拥有三种状态的类型，在normal情况下，背景色为白色。
	 * <p>
	 * <b>noBorder</b>：没有边框的类型。
	 * <p>
	 * <b>towImage</b>：两种图片作为按钮的外观的类型，为默认类型，需要设置normalImage和overImage两种样式。
	 **/
	[Style(name="buttonType",inherit="no",enumeration="circleRadius,normalTowState,normalThreeState,noBorder,towImage")]
	public class ClickButton2 extends Button
	{
		/**
		 * 圆边按钮
		 **/
		protected static const CIRCLE_RADIUS_TYPE:String = "circleRadius";
		
		/**
		 * 普通按钮，只有两种状态
		 **/
		protected static const NORMAL_TOW_STATE_TYPE:String = "normalTowState";
		
		/**
		 * 普通按钮，三种状态，在normal状态下，背景为透明
		 **/
		protected static const NORMAL_THREE_STATE_TYPE:String = "normalThreeState";
		
		/**
		 * 两种状态的按钮，normal状态下，背景透明且没有边框
		 **/
		protected static const NO_BORDER_TYPE:String = "noBorder";
		
		/**
		 * 以两种类型的图片作为按钮的外观的按钮，为默认样式
		 **/
		protected static const TWO_IMAGE_TYPE:String = "towImage";
		
		
		private var _tag:Object;
		private var _type:String = "";
		
		/**
		 * 按钮的保留标记，可存储与该按钮相关的信息
		 **/
		public function set tag(value:Object):void
		{
			_tag = value;
		}
		
		/**
		 * 按钮的保留标记，可存储与该按钮相关的信息
		 **/
		public function get tag():Object
		{
			return _tag;
		}
		
		public function ClickButton2()
		{
			super();
			setStyle("iconPlacement","left");
			buttonMode = true;
			addEventListener(FlexEvent.CREATION_COMPLETE,function(event:FlexEvent):void
			{
				setSkin();
			});
		}
		
		private function setSkin():void
		{
			_type = getStyle("buttonType");
			switch(_type)
			{
				case CIRCLE_RADIUS_TYPE:
					setStyle("skinClass",CircleRadiusButtonSkin);
					break;
				case NORMAL_TOW_STATE_TYPE:
					setStyle("skinClass",TowStateButtonSkin);
					break;
				case NORMAL_THREE_STATE_TYPE:
					setStyle("skinClass",ThreeStateButtonSkin);
					break;
				case NO_BORDER_TYPE:
					setStyle("skinClass",NoBorderButtonSkin);
					break;
				default:
					setStyle("skinClass",ClickButtonSkin);
					break;
			}
		}
	}
}