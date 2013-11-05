/**
 * 类文件名：SearchWorker.as
 * 作者：温杨彪
 * 描述：查询的逻辑操作全部交由该类实现。
 * 版本信息：1.0
 * 创建时间：2012-09-17。搜索模块代码重构
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 **/
package widgets.Search
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.CompositeSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.TextSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	
	public class SearchWorker
	{
		/**
		 * 通用POI分类信息
		 **/
		public var generalPOICatalog:XML;
		public var graphicsLayer:GraphicsLayer;
		
		/**
		 * 主键名称
		 **/
		public var oidFieldName:String;
		
		/**
		 * 城市匹配语句
		 **/
		public var citymatch:String;
		/**
		 * 地区匹配语句
		 **/
		public var districtmatch:String;
		
		/**
		 * POI大类匹配语句
		 **/
		public var catalogmatch:String;
		
		/**
		 * POI小类匹配语句
		 **/
		public var subcatalogmatch:String;
		
		/**
		 * 属性匹配语句
		 **/
		public var expression:String;
		private var _resultMarkerSymbol:SimpleMarkerSymbol;
		private var _symbolsPerPage:Array=[];
		private const RECORDS_PER_PAGE:uint = 9;
		
		public function SearchWorker()
		{
		}
		
		public function queryByFilter(filter:QueryFilter,responder:IResponder):void
		{
			var queryTask:QueryTask = new QueryTask(filter.url);
			var strExpress:String = "";
			var query:Query = new Query();
			
			//------------关键字--------------
			if(filter.keyword != "")
			{
				strExpress = expression.replace("[value]",filter.keyword);
			}
			//-----------POI大类过滤条件---------------
			if(filter.poiCatalogCode != "")
			{
				strExpress == "" ? strExpress = catalogmatch.replace("[value]",filter.poiCatalogCode):
					strExpress = strExpress + " and " + catalogmatch.replace("[value]",filter.poiCatalogCode);
			}
			
			//-----------POI小类类过滤条件---------------
			if(filter.subPOICatalogCode != "")
			{
				strExpress = strExpress + " and " + subcatalogmatch.replace("[value]",filter.subPOICatalogCode);
			}
			
			query.where = strExpress;
			
			query.outFields = filter.outFields; //提升效率
			query.returnGeometry = true;
			queryTask.useAMF = true;
			
			queryTask.execute(query, new AsyncResponder(queryFilter_resultHandler, queryFilter_faultHandler, responder));
		}
		private function queryFilter_resultHandler(featureSet:FeatureSet,token:Object):void
		{
			var responder:IResponder = token as IResponder;
			responder.result(featureSet);
		}
		private function queryFilter_faultHandler(fault:Fault,token:Object):void
		{
			var responder:IResponder = token as IResponder;
			responder.fault(fault);
		}
		
		private function queryDetailByIds_resultHandler(featureSet:FeatureSet,token:Object = null):void
		{
			var responder:IResponder = token as IResponder;
			responder.result(featureSet);
		}
		
		public function queryDetailByIds(queryFilter:QueryFilter,responder:IResponder):void
		{
			if(queryFilter.oids.length<1)
			{
				return;
			}
			var queryTask:QueryTask = new QueryTask(queryFilter.url);
			queryTask.useAMF = true;
			
			var query:Query = new Query();
			query.objectIds = queryFilter.oids;
			//输出字段
			query.returnGeometry = false;
			query.outFields = queryFilter.outFields;
			
			queryTask.execute(query, new AsyncResponder(queryDetailByIds_resultHandler, queryFilter_faultHandler, responder));
		}
		
		public function queryMedias():void
		{
			
		}
	}
}