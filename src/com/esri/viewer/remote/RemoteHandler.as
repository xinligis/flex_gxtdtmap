/**    
 * 类文件名：RemoteHandler.as
 * 
 * 版本信息：1.0
 * 创建时间：2012-2-27
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 * 
 */ 
package com.esri.viewer.remote
{
	import com.esri.viewer.AppEvent;
	import com.esri.viewer.ConfigData;
	
	import flash.net.registerClassAlias;
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	
	/**
	 * <p>
	 * description: 远程对象调用对象，单件对象
	 * </p>
	 * @author:温杨彪
	 * @version: 1.0
	 * @date:2012-2-27
	 * @since:1.0
	 */ 
	public class RemoteHandler
	{
		private static var ro:RemoteObject = new RemoteObject("digitalMapDestination");
		private static var _destination:String;
//		private static var _registedRemoteResult:Boolean = false;
//		registerClassAlias("com.esrichina.portal.flex.remoteobject.RemoteResult", RemoteResult);
//		public static function set destination(value:String):void
//		{
//			ro.destination = value;
//		}
		public function RemoteHandler(){
			
		}
		
		/**
		 * 
		 * @param args 参数
		 * @param method 调用方法
		 */
//		public static function invoke(destination:String,method:String, args:Array):AsyncToken
//		{
//			var ro:RemoteObject = new RemoteObject();
//			if(destination == "")
//			{
//				Alert.show("错误：远程对象的destination没有配置");
//				return null;
//			}
//			ro.destination = destination;
//			var oper:AbstractOperation=ro.getOperation(method);
//			var result:AsyncToken=oper.send.apply(oper,args);
//			
//			return result;
//		}
		
		/**
		 * 执行远程调用方法
		 * <br />
		 * 修改，在方法内直接绑定远程调用的回调方法。温杨彪；2012-3-28
		 * @param remoteFunction 远程调用方法名
		 * @param args 远程调用参数，以数组形式组织，与远程方法参数顺序一致
		 * @param responder 远程调用响应
		 **/
		public static function invoke(remoteFunction:String,args:Array = null,responder:IResponder = null):void
		{
//			if(_registedRemoteResult == false)
//			{
//				_registedRemoteResult = true
//			}
			if(ro.destination == "")
			{
				Alert.show("错误：远程对象的destination没有配置");
				return;
			}
			var oper:AbstractOperation=ro.getOperation("remoteInvoke");
			var result:AsyncToken=oper.send.apply(oper,[remoteFunction,args]);
			result.addResponder(new AsyncResponder(handleResult, handleFault, responder));
		}
		
		protected static function handleResult(event:ResultEvent, token:Object = null):void
		{
			var responder:IResponder = token as IResponder;
			var flag:Boolean =  event.result is com.esri.viewer.remote.RemoteResult; 
			if(flag)
			{
				//通知用户已经注销
				if((event.result as RemoteResult).code == RemoteResult.RESULT_USER_NOLOGIN)
				{
					AppEvent.dispatch(AppEvent.USER_LOG_OFF);
				}
				if(responder)
				{
				responder.result(event.result);
				}
			}
			else
			{
				if(responder)
				{
				responder.fault(new Fault("404", "返回结果类型错误", "返回结果应该为RemoteResult"));
				}
			}
		}
		
		protected static function handleFault(fault:FaultEvent, token:Object = null):void
		{
			trace(fault.message);	
			var responder:IResponder = token as IResponder;
			responder.fault(fault.fault);
		}
	}
}
