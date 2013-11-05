package com.esri.viewer.utils
{
	import flash.external.ExternalInterface;
	
	import mx.utils.URLUtil;

	public class UrlConstructor
	{
		public function UrlConstructor()
		{
		}
		
		/**
		 * 获取正确的url地址。如果传入的是http地址，则不做修改。如果传入的是相对地址，则拼接现在地址栏上的url中的主机名和端口号后返回回来。
		 **/
		public static function getUrl(url:String):String
		{
			if(URLUtil.isHttpURL(url))
			{
				return url;
			}
			var browseUrl:String = String(ExternalInterface.call('window.location.href.toString'));
			var serverPort:String = URLUtil.getServerNameWithPort(browseUrl);
			serverPort = "http://" + serverPort;
			return URLUtil.getFullURL(serverPort,url);
		}
	}
}