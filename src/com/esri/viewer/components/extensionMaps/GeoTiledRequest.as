package com.esri.viewer.components.extensionMaps
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.utils.StringUtil;
	
	public class GeoTiledRequest extends TiledRequest
	{

		public function GeoTiledRequest()
		{
			super();
			
		}

		override public function getURLRequest(level:Number, row:Number, col:Number):URLRequest
		{
			var url:String;

			//修改山西地图服务的加载方式，_baseURL为http://……？T=；张丹荔；2011-05-24
			url = StringUtil.substitute("{0}&X={1}&Y={2}&L={3}",
				_baseURL, String(col), String(row),String(level + 1));
			
			_urlRequest.url = url;
			return _urlRequest;
		}
	}
}