/**    
 * 类文件名：LoadImageByBytesUtil.as
 * 
 * 版本信息：1.0
 * 创建时间：2012-2-27
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 * 
 */ 
package com.esri.viewer.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * <p>
	 * description: 加载二进制流图片类
	 * </p>
	 * @author:温杨彪
	 * @version: 1.0
	 * @date:2012-2-27
	 * @since:1.0
	 */ 
	public class LoadImageByBytesUtil
	{
		/**
		 * 加载图片
		 * @param bytes 二进制流
		 * @param loadCompleteHandler 加载成功后的回调方法。方法接受一个参数bitmap:Bitmap。该参数就是Image的数据源
		 **/
		public static function load(bytes:ByteArray,loadCompleteHandler:Function):void
		{
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,load_complete);
			function load_complete(event:Event):void
			{
				var bitmap:Bitmap = Bitmap(loader.content);
				loadCompleteHandler(bitmap);
				loader.removeEventListener(Event.COMPLETE,load_complete);
			}
			loader.loadBytes(bytes);
		
		}
	}
}