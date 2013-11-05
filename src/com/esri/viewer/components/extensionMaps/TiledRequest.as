package com.esri.viewer.components.extensionMaps
{
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;

	public class TiledRequest
	{
		protected var _urlRequest:URLRequest = null;
		protected var _baseURL:String;
		public function TiledRequest()
		{
			_urlRequest = new URLRequest();
		}
		//王红亮，2011-04-27
		public function set baseURL(url:String):void
		{
			if(!url)
				return;
			if(url == "")
				return;			
			_baseURL = url;
		}
		public function get baseURL():String
		{
			return _baseURL;
		}
		public function getURLRequest(level:Number, row:Number, col:Number):URLRequest
		{			
			return null;
		}
	}
}