package com.esri.viewer.components.extensionMaps
{
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;
	
	public class TiandituTiledRequest extends TiledRequest
	{
		//public var serviceNames:Array;
		
		public function TiandituTiledRequest()
		{
			super();
		}
		
		override public function getURLRequest(level:Number, row:Number, col:Number):URLRequest
		{
			var url:String;
			url = super._baseURL.replace("{d}", String(Math.round(Math.random() * 6) + 1));
			url = StringUtil.substitute("{0}&X={1}&Y={2}&L={3}",
				url, String(col), String(row),String(level + 1));
			
			_urlRequest.url = url;
			return _urlRequest;
		}
	}
}