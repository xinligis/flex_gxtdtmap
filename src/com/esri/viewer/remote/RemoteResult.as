package com.esri.viewer.remote
{
	[RemoteClass(alias="com.esrichina.portal.flex.remoteobject.RemoteResult")]
	public class RemoteResult
	{
		public static const RESULT_OK:int = 200;
		public static const RESULT_CLIENT_ERROR:int = 404;
		public static const RESULT_SERVER_ERROR:int = 500;
		public static const RESULT_USER_NOLOGIN:int = 40001;
		public var code:int;
		public var errorMessage:String;
		public var content:Object;
		public function RemoteResult()
		{
		}
	}
}