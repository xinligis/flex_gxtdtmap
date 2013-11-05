package com.esri.viewer.managers
{
	import com.esri.viewer.LoginUser;
	import com.esri.viewer.remote.RemoteResult;
	
	import flash.net.registerClassAlias;
	
	import mx.messaging.messages.RemotingMessage;
	import mx.messaging.messages.SOAPMessage;
	
	import widgets.Bookmark.Bookmark;
	import widgets.MapCorrection.MapCorrectionVO;
	import widgets.Weather.WeatherInfo;
	
	registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);
	registerClassAlias("mx.messaging.messages.SOAPMessage", SOAPMessage);
	registerClassAlias("com.esrichina.portal.flex.remoteobject.RemoteResult", RemoteResult); 
	registerClassAlias("com.esrichina.portal.flex.pojo.LoginUser", LoginUser);
	registerClassAlias("com.esrichina.portal.flex.pojo.MapCorrection",MapCorrectionVO);
	registerClassAlias("com.esrichina.portal.flex.pojo.Weather", WeatherInfo);
	registerClassAlias("widgets.Bookmark.Bookmark", Bookmark);
	/**
	 * 为模块中所有用到的RemoteObject的对象进行注册
	 */
	public class RegisterClass4Module
	{
		public function RegisterClass4Module()
		{
		}
	}
}