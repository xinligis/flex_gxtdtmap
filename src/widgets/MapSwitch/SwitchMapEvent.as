/**    
 * 类文件名：SwitchMapEvent.as
 * 
 * 版本信息：1.0
 * 创建时间：2012-3-13
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 * 
 */ 
package widgets.MapSwitch
{
	import flash.events.Event;
	/**
	 * <p>
	 * description: 地图切换时，点击按钮切换地图事件对象
	 * </p>
	 * @author:温杨彪
	 * @version: 1.0
	 * @date:2012-3-3
	 * @since:1.0
	 */ 
	public class SwitchMapEvent extends Event
	{
		public static const SWITCHMAP:String = "switchMap";
		public var label:String
		public function SwitchMapEvent(label:String)
		{
			super(SWITCHMAP, false, false);
			this.label = label;
		}
	}
}