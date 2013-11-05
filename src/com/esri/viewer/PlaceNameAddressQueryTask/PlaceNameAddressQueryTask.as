package com.esri.viewer.PlaceNameAddressQueryTask
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.tasks.BaseTask;
	
	import flash.net.URLVariables;
	
	import mx.logging.Log;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	public final class PlaceNameAddressQueryTask extends BaseTask
	{
		private var _lastQueryResult:PlaceNameAddressQueryResult;
		public function get lastQueryResult():PlaceNameAddressQueryResult
		{
			return _lastQueryResult;
		}
		override public function PlaceNameAddressQueryTask(url:String=null)
		{
			super(url);
		}
		
		/**
		 * 重载父类的结果处理函数，改变父类默认把结果作为json对象的处理方式，
		 * 而是采用xml格式解析
		 */
		protected function handleResult(event:ResultEvent, asyncToken:AsyncToken, operation:Function):void
		{
			if(event.result == "")
			{
				super.handleStringError("Empty result.Please Check parameters", asyncToken);
				return;
			}
			var	resultFault:mx.rpc.Fault;
			var responder:IResponder;
			try
			{
				var xml:XML = new XML(event.result as String);
				operation.call(this, xml, asyncToken);
			}
			catch(resultError:Error)
			{
				if(mx.logging.Log.isError())
				{
					this.logger.error("{0}::{1}", id, resultError.message);
				}
				resultFault = new Fault(null, resultError.message);
				for each(responder in asyncToken.responders)
				{
					responder.fault(resultFault);
				}
				dispatchEvent(new mx.rpc.events.FaultEvent(mx.rpc.events.FaultEvent.FAULT, false, true, resultFault));
			}
		}
		
		/**
		 * 全文检索关键字的任务接口
		 * @queryParameters 查询的参数
		 * @responder 查询执行完成之后的响应对象
		 */
		public function queryPlaceNameAddress(queryParameters:PlaceNameAddressQueryParameters, responder:IResponder):AsyncToken
		{
			var param:URLVariables = new URLVariables();
			param.queryStr = encodeURI(queryParameters.keyword);
			return	sendURLVariables("", param, responder, this.handleFullTextSearchResult);
		}
		
		/**
		 * 解析全文查询返回的结果，xml格式
		 * @result 结果的内容，xml格式
		 * @asyncToken 客户端提交查询时，返回的异步token
		 */
		private function handleFullTextSearchResult(result:Object, asyncToken:AsyncToken):void
		{
			var xml:XML = result as XML;
			if(xml == null)
			{
				return;
			}
			_lastQueryResult = new PlaceNameAddressQueryResult();
			_lastQueryResult.count = parseInt(xml.count);
			/*_lastQueryResult.status = parseInt(xml.status);
			_lastQueryResult.geometryType = parseInt(xml.type);*/
			for each(var featureXML:XML in xml.result)
			{
				var x:String = featureXML.longitude;
				var y:String = featureXML.latitude;
				var geometry:Geometry = new MapPoint(Number(x), Number(y));
				if(geometry == null)
				{
					continue;
				}
				var name:String = featureXML.name;
				var query_address:String = featureXML.query_address;
				var formatted_address:String = featureXML.formatted_address;
				var attributes:Object = {name:name, query_address:query_address, formatted_address:formatted_address};
				var graphic:Graphic = new Graphic(geometry, null, attributes);
				_lastQueryResult.features.push(graphic);
			}
			for each(var responder:IResponder in asyncToken.responders)
			{
				responder.result(_lastQueryResult);
			}
			dispatchEvent(new PlaceNameAddressQueryEvent(PlaceNameAddressQueryEvent.FULL_TEXT_SEARCH_COMPLETE, _lastQueryResult));
		}
		
		/**
		 * 解析原始的坐标串，并转换成ags的geometry
		 * 目前仅仅支持MapPoin
		 */
		private function raw2Geometry(raw:String):Geometry
		{
			//验证格式POINT(  )
			var pattern:RegExp = /\s*POINT\s*\(\s*\d+.\d*\s+\d+.\d*\)\s*/g;
			if(raw.match(pattern) == null)
			{
				return null;
			}
			//判断类型
			var array:Array = raw.split(/\(|\)/);
			//几何类型
			var value:String = mx.utils.StringUtil.trim(array[0]);
			if(value == "POINT")
			{
				value = mx.utils.StringUtil.trim(array[1]);
				array = value.split(/\s+/);
				var x:String = array[0];
				var y:String = array[1];
				return new MapPoint(Number(x), Number(y));
			}
			
			return null;
		}
	}
}