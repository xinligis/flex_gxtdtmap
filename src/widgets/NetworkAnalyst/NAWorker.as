/**    
 * 类文件名：NAWorker.as
 * 作者：温杨彪
 * 描述：路网分析中所有的逻辑操作者。包括，用户在文本框输入时的提示信息查询、起点、终点、途经点的管理，最终的调用NA Server的操作等
 * 版本信息：1.0
 * 创建时间：2012-4-24
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 * 
 */ 

package widgets.NetworkAnalyst
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.RouteEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.FillSymbol;
	import com.esri.ags.symbols.MarkerSymbol;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.RouteTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.tasks.supportClasses.RouteParameters;
	import com.esri.viewer.utils.Hashtable;
	
	import flash.events.EventDispatcher;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	
	/**
	 * 需要验证起点事件
	 **/
	[Event(name="validStart",type="widgets.NetworkAnalyst.NAEvent")]
	
	/**
	 * 需要验证途经点事件
	 **/
	[Event(name="validPass",type="widgets.NetworkAnalyst.NAEvent")]
	
	/**
	 * 需要验证终点事件
	 **/
	[Event(name="validEnd",type="widgets.NetworkAnalyst.NAEvent")]
	
	/**
	 * 开始执行网络分析
	 **/
	[Event(name="startExcute",type="widgets.NetworkAnalyst.NAEvent")]
	
	/**
	 * 执行网络分析完成
	 **/
	[Event(name="excuteCompelete",type="widgets.NetworkAnalyst.NAEvent")]
	
	/**
	 * 执行网络分析失败
	 **/
	[Event(name="excuteFault",type="widgets.NetworkAnalyst.NAEvent")]
	public class NAWorker extends EventDispatcher
	{
		private var _queryTask:QueryTask;
		
		private var _poiOIDField:String;
		
		/**
		 * POI的主键名称
		 **/
		public function set poiOIDField(value:String):void
		{
			_poiOIDField = value;
		}
		
		public function get poiOIDField():String
		{
			return _poiOIDField;
		}
		
		/**
		 * POI的地址字段
		 **/
		private var _poiAddField:String = "";
		
		public function set poiAddField(value:String):void
		{
			_poiAddField = value;
		}
		
		public function get poiAddField():String
		{
			return _poiAddField;
		}
		
		/**
		 * 用户输入时的提示信息搜索Task的URL
		 **/
		public function set queryAssetTaskUrl(value:String):void
		{
			if(_queryTask!=null)
			{
				_queryTask.url = value;
			}
		}
		
		public function get queryAssetTaskUrl():String
		{
			if(_queryTask!=null)
			{
				return _queryTask.url;
			}
			return "";
		}
		
		/**
		 * POI的显示名字字段
		 **/
		private var _poiDisplayField:String;
		
		public function get poiDisplayField():String
		{
			return _poiDisplayField;
		}
		
		public function set poiDisplayField(value:String):void
		{
			_poiDisplayField = value;
		}
		
		/**
		 * 用户输入提示查询的表达式
		 **/
		private var _assetQueryExpression:String;
		
		public function get assetQueryExpression():String
		{
			return _assetQueryExpression;
		}
		
		public function set assetQueryExpression(value:String):void
		{
			_assetQueryExpression = value;
		}
		
		/**
		 * 起点Graphic
		 **/
		private var _startGraphic:Graphic = null;
		
		/**
		 * 终点Graphic
		 **/
		private var _endGraphic:Graphic = null;
		
		/**
		 * 障碍Graphic列表
		 **/
		private var _barrierGraphics:Array = [];
		
		/**
		 * 起点符号
		 **/
		private var _startSymbol:MarkerSymbol = null;
		/**
		 * 起点符号
		 **/
		public function set startSymbol(value:MarkerSymbol):void
		{
			_startSymbol = value;
		}
		
		public function get startSymbol():MarkerSymbol
		{
			return _startSymbol;
		}
		/**
		 * 终点符号
		 **/
		private var _endSymbol:MarkerSymbol = null;
		/**
		 * 终点符号
		 **/
		public function set endSymbol(value:MarkerSymbol):void
		{
			_endSymbol = value;
		}
		
		public function get endSymbol():MarkerSymbol
		{
			return _endSymbol;
		}
		/**
		 * 障碍符号
		 **/
		private var _barrierSymbol:FillSymbol;
		/**
		 * 障碍符号
		 **/
		public function set barrierSymbol(value:FillSymbol):void
		{
			_barrierSymbol = value;
		}
		
		public function get barrierSymbol():FillSymbol
		{
			return _barrierSymbol;
		}
		
		/**
		 * 途经点符号
		 **/
		private var _passSymbol:MarkerSymbol;
		/**
		 * 途经点符号
		 **/
		public function set passSymbol(value:MarkerSymbol):void
		{
			_passSymbol = value;
		}
		/**
		 * 途经点符号
		 **/
		public function get passSymbol():MarkerSymbol
		{
			return _passSymbol;
		}
		
		
		private var _graphicsLayer:GraphicsLayer = null;
		
		public function set graphicsLayer(value:GraphicsLayer):void
		{
			_graphicsLayer = value;
		}
		
		public function get graphicsLayer():GraphicsLayer
		{
			return _graphicsLayer;
		}
		
		private var _map:Map = null;
		
		public function set map(value:Map):void
		{
			_map = value;
		}
		
		public function get map():Map
		{
			return _map;
		}
		
		/**
		 * passid与实际途经点Graphic的映射<int,Graphic>
		 **/
		private var _id2passPtTable:Hashtable = null;
		
		private var _currentSubmitInfo:SubmitInfo = null;
		
		public function NAWorker()
		{
			_queryTask = new QueryTask();
			_queryTask.useAMF = true;
			_id2passPtTable = new Hashtable();
			_routeTask = new RouteTask();
			_routeTask.concurrency = "last";
			_routeTask.requestTimeout = 30;
			_routeTask.showBusyCursor = true;
			_routeTask.addEventListener(RouteEvent.SOLVE_COMPLETE,routeTask_solveHandler);
			_routeTask.addEventListener(FaultEvent.FAULT,routeTask_faultHandler);
			super();
		}
		
		private var _routeTask:RouteTask;
		
		/**
		 * 路网分析task url
		 **/
		public function get routeTaskUrl():String
		{
			if(_routeTask!=null)
			{
				return _routeTask.url;
			}
			return "";
		}
		/**
		 * 路网分析task url
		 **/
		public function set routeTaskUrl(value:String):void
		{
			if(_routeTask!=null)
			{
				_routeTask.url = value;
			}
		}
		
		/**
		 * 不走高速限制属性的名字
		 **/
		public var noHighWayAttrName:String;
		
		/**
		 * 时间最短属性名字
		 **/
		public var timeImpedance:String;
		
		/**
		 * 距离最短属性名字
		 **/
		public var distanceImpedance:String;
		
		
		/**
		 * 查询提示信息
		 **/
		public function queryAssetWords(word:String,callback:Function):void
		{
			var query:Query = new Query();
			query.returnGeometry = false;
			query.outFields = [_poiDisplayField,_poiOIDField];
			query.where = _assetQueryExpression.replace("[VALUE]", word);
			_queryTask.execute(query,
				new AsyncResponder(queryAssetWords_resultHandler,queryAssetWords_faultHandler,callback));
		}
		
		private function queryAssetWords_resultHandler(featureSet:FeatureSet,token:Object = null):void
		{
			var callback:Function = token as Function;
			
			var resultArray:Array = [];
			var len:uint = featureSet.features.length;
			len = len > 30 ? 30 : len;
			var graphic:Graphic;
			for(var index:uint = 0; index < len; ++index)
			{
				graphic = featureSet.features[index];
				resultArray.push(graphic.attributes[_poiDisplayField]);
			}
			
			if(callback != null)
			{
				callback(resultArray,featureSet);
			}
		}
		
		private function queryAssetWords_faultHandler(fault:Object,token:Object = null):void
		{
			trace("queryAssetWords_faultHandler");
		}
		
		/**
		 * 查询起点、终点或者途径点的实际Graphic
		 **/
		public function queryGraphicEntity(g:Graphic,queryType:String):void
		{
			var query:Query = new Query();
			query.returnGeometry = true;
			query.outFields = [_poiDisplayField];
			query.objectIds = [g.attributes[_poiOIDField]];
			_queryTask.execute(query,
				new AsyncResponder(queryGraphicEntity_resultHandler,queryGraphicEntity_faultHandler,
					{querytype:queryType,origngraphic:g}));
		}
		
		private function queryGraphicEntity_resultHandler(featureSet:FeatureSet,token:Object = null):void
		{
			var queryType:String = token.querytype.toString();
			switch(queryType)
			{
				case NetworkAnalystWidget.GRAPHIC_TYPE_START:
					//查询的是起点
					setStartGraphic(featureSet.features[0]);
					break;
				case NetworkAnalystWidget.GRAPHIC_TYPE_END:
					//查询的是终点
					setEndGraphic(featureSet.features[0]);
					break;
				case NetworkAnalystWidget.GRAPHIC_TYPE_PASS:
					//查询的是途经点
					var orignGraphic:Graphic = token.origngraphic as Graphic;
					setPassGraphic(featureSet.features[0],orignGraphic.attributes.passid);
					break;
			}
		}
		
		private function queryGraphicEntity_faultHandler(fault:Object,token:Object = null):void
		{
			trace("queryGraphicEntity_faultHandler");
		}
		
		/**
		 * 设置起点
		 **/
		public function setStartGraphic(g:Graphic):void
		{
			if(!g)
			{
				return;
			}
			if(_startGraphic == null)
			{
				_startGraphic = new Graphic(g.geometry,_startSymbol,g.attributes);
				_graphicsLayer.add(_startGraphic);
			}
			else
			{
				_startGraphic.geometry = g.geometry;
				_startGraphic.attributes = g.attributes;
			}
//			_map.centerAt(_startGraphic.geometry as MapPoint);
		}
		
		/**
		 * 设置终点
		 **/
		public function setEndGraphic(g:Graphic):void
		{
			if(!g)
			{
				return;
			}
			if(_endGraphic == null)
			{
				_endGraphic = new Graphic(g.geometry,_endSymbol,g.attributes);
				_graphicsLayer.add(_endGraphic);
			}
			else
			{
				_endGraphic.geometry = g.geometry;
				_endGraphic.attributes = g.attributes;
			}
//			_map.centerAt(_endGraphic.geometry as MapPoint);
		}
		
		/**
		 * 设置障碍
		 **/
		private function setBarrierGraphic(g:Graphic):void
		{
			var barrierGraphic:Graphic = new Graphic(g.geometry,_barrierSymbol,g.attributes);
			_graphicsLayer.add(barrierGraphic);
			_barrierGraphics.push(barrierGraphic);
		}
		
		/**
		 * 设置途经点
		 **/
		private function setPassGraphic(g:Graphic,passid:int):void
		{
			var passGraphic:Graphic = new Graphic(g.geometry,_passSymbol,g.attributes);
			passGraphic.attributes.passid = passid;
			_id2passPtTable.add(passGraphic.attributes.passid,passGraphic);
			_graphicsLayer.add(passGraphic);
//			_map.centerAt(passGraphic.geometry as MapPoint);
		}
		
		/**
		 * 设置绘制的图形
		 * @param g 绘制的图形
		 * @param type 绘制的类型，起点、终点、途经点或者障碍
		 **/
		public function setDrawGraphic(g:Graphic,type:String):void
		{
			if(g.attributes == null)
			{
				g.attributes = new Object();
			}
			switch(type)
			{
				case NetworkAnalystWidget.GRAPHIC_TYPE_START:
					g.attributes[_poiDisplayField] = "手动绘制";
					setStartGraphic(g);
					break;
				case NetworkAnalystWidget.GRAPHIC_TYPE_END:
					g.attributes[_poiDisplayField] = "手动绘制";
					setEndGraphic(g);
					break;
				case NetworkAnalystWidget.GRAPHIC_TYPE_BARRIER:
					setBarrierGraphic(g);
					break;
				case NetworkAnalystWidget.GRAPHIC_TYPE_PASS:
					g.attributes[_poiDisplayField] = "手动绘制";
					setPassGraphic(g,g.attributes.passid);
					break;
			}
		}
		
		/**
		 * 删除指定ID的途经点
		 * @param id 途经点ID
		 **/
		public function deletePassGraphic(id:int):void
		{
			var g:Graphic = _id2passPtTable.find(id);
			_graphicsLayer.remove(g);
			_id2passPtTable.remove(id);
		}
		
		/**
		 * 重置所有输入参数和清除结果
		 **/
		public function resetAndCleanAll():void
		{
			_graphicsLayer.clear();
			_id2passPtTable.clear();
			_startGraphic = null;
			_endGraphic = null;
			_barrierGraphics = [];
		}
		
		/**
		 * 验证参数是否正确
		 **/
		public function validSubmitInfo(submitInfo:SubmitInfo):void
		{
			_currentSubmitInfo = submitInfo;
			
			var result:Boolean = false;
			
			//验证起点
			result = validStart(_currentSubmitInfo.startName);
			if(result == false)
				return;
			
			//验证途经点
			result = validPass();
			if(result == false)
				return;
			
			//验证终点
			result = validEnd(_currentSubmitInfo.endName);
			if(result == false)
				return;
			
			//验证成功
			//执行
			submitNAWork();
		}
		
		/**
		 * 验证起点
		 **/
		private function validStart(startName:String):Boolean
		{
			var naEvent:NAEvent;
			var validInfo:ValidInfo;
			
			if(_startGraphic == null || _startGraphic.attributes[_poiDisplayField] != startName)
			{
				validInfo = new ValidInfo();
				validInfo.invalidType = ValidInfo.INVALID_TYPE_START;
				validInfo.invalidName = startName;
				naEvent = new NAEvent(NAEvent.VALID_START_EVENT);
				naEvent.validInfo = validInfo;
				dispatchEvent(naEvent);
				return false;
			}
			return true;;
		}
		
		/**
		 * 验证途经点
		 **/
		private function validPass():Boolean
		{
			var naEvent:NAEvent;
			var validInfo:ValidInfo;
			var len:int = _currentSubmitInfo.passInfos.length;
			for(var i:int = 0;i<len;i++)
			{
				var passinfo:Object = _currentSubmitInfo.passInfos[i];
				if(passinfo.passid<1)
				{
					//说明是不确定点
					validInfo = new ValidInfo();
					validInfo.invalidType = ValidInfo.INVALID_TYPE_PASS;
					validInfo.invalidName = passinfo.passname;
					naEvent = new NAEvent(NAEvent.VALID_PASS_EVENT);
					naEvent.validInfo = validInfo;
					dispatchEvent(naEvent);
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 验证终点
		 **/
		private function validEnd(endName:String):Boolean
		{
			var naEvent:NAEvent;
			var validInfo:ValidInfo;
			if(_endGraphic == null || _endGraphic.attributes[_poiDisplayField] != endName)
			{
				validInfo = new ValidInfo();
				validInfo.invalidType = ValidInfo.INVALID_TYPE_END;
				validInfo.invalidName = endName;
				naEvent = new NAEvent(NAEvent.VALID_END_EVENT);
				naEvent.validInfo = validInfo;
				dispatchEvent(naEvent);
				return false;;
			}
			return true;
		}
		
		/**
		 * 使用POI的名称查询符合要求的所有POI的Ids
		 * @param name 查询名称
		 * @param resultHandler 查询成功后的回调方法，resultHandler(ids:Array):void
		 **/
		public function queryPoiIdsByName(name:String,resultHandler:Function):void
		{
			var query:Query = new Query();
			query.returnGeometry = false;
			query.outFields = [_poiOIDField];
			query.where = _assetQueryExpression.replace("[VALUE]", name);
			_queryTask.execute(query,
				new AsyncResponder(queryPoiIdsByName_resultHandler,queryPoiIdsByName_faultHandler,resultHandler));
		}
		
		private function queryPoiIdsByName_resultHandler(featureSet:FeatureSet,token:Object = null):void
		{
			var resultHandler:Function = token as Function;
			
			var ids:Array = [];
				
			var len:uint = featureSet.features.length;
			var graphic:Graphic;
			for(var index:int = 0; index < len; index++)
			{
				graphic = featureSet.features[index];
				ids.push(graphic.attributes[_poiOIDField]);
			}
			resultHandler(ids);
		}
		
		private function queryPoiIdsByName_faultHandler(fault:Fault,token:Object = null):void
		{
			trace("queryPoiIdsByName_faultHandler");
		}
		
		public function queryDetailPoisByIds(ids:Array,resultHandler:Function):void
		{
			var query:Query = new Query();
			query.returnGeometry = true;
			query.outFields = [_poiOIDField,_poiDisplayField];
			if(_poiAddField != "")
			{
				query.outFields.push(_poiAddField);
			}
			query.objectIds = ids;
			_queryTask.execute(query,
				new AsyncResponder(queryDetailPoisByIds_resultHandler,queryDetailPoisByIds_faultHandler,resultHandler));
		}
		private function queryDetailPoisByIds_resultHandler(featureSet:FeatureSet,token:Object = null):void
		{
			var resultHandler:Function = token as Function;
			resultHandler(featureSet);
		}
		private function queryDetailPoisByIds_faultHandler(fault:Fault,token:Object = null):void
		{
			trace("queryPoiIdsByName_faultHandler");
		}
		
		/**
		 * 设置验证后的起点
		 **/
		public function setValidStart(g:Graphic):void
		{
			setStartGraphic(g);
			
			var result:Boolean = false;
			
			//验证途经点
			result = validPass();
			if(result == false)
				return;
			
			//验证终点
			result = validEnd(_currentSubmitInfo.endName);
			if(result == false)
				return;
			
			//验证成功
			//执行
			submitNAWork();
		}
		
		/**
		 * 设置验证后的途经点
		 **/
		public function setValidPass(g:Graphic):void
		{
			var result:Boolean = false;
			//设置
			var len:int = _currentSubmitInfo.passInfos.length;
			for(var i:int = 0;i<len;i++)
			{
				var passinfo:Object = _currentSubmitInfo.passInfos[i];
				if(passinfo.passid<1)
				{
					passinfo.passname = g.attributes[_poiDisplayField];
					passinfo.passid = createPassId();
					setPassGraphic(g,passinfo.passid);
					break;
				}
			}
			
			//验证途经点
			result = validPass();
			if(result == false)
				return;
			
			//验证终点
			result = validEnd(_currentSubmitInfo.endName);
			if(result == false)
				return;
			
			//验证成功
			//执行
			submitNAWork();
		}
		
		/**
		 * 生成途经点ID
		 **/
		private function createPassId():int
		{
			var id:int = 1;
			var flag:Boolean = true;
			while(flag)
			{
				if(_id2passPtTable.find(id) != null)
				{
					id++;
				}
				else
				{
					flag = false;
				}
			}
			return id;
		}
		
		/**
		 * 设置验证后的终点
		 **/
		public function setValidEnd(g:Graphic):void
		{
			setEndGraphic(g);
			//执行
			submitNAWork();
		}
		
		/**
		 * 执行网络分析
		 **/
		private function submitNAWork():void
		{
			var naEvent:NAEvent = new NAEvent(NAEvent.START_EXCUTE_EVENT);
			dispatchEvent(naEvent);
			
			var routeParams:RouteParameters = new RouteParameters();
			routeParams.returnRoutes = true;
			routeParams.returnDirections = true;
			routeParams.outSpatialReference = _map.spatialReference;
//			routeParams.directionsLengthUnits = 
			
			var stops:FeatureSet = new FeatureSet([]);
			var g:Graphic = new Graphic(_startGraphic.geometry);
			g.attributes = new Object;
			g.attributes[_poiDisplayField] = _startGraphic.attributes[_poiDisplayField];
			stops.features.push(g);
			if(_id2passPtTable.isEmpty() == false)
			{
				//有途经点
				var keys:Array = _id2passPtTable.getKeySet();
				for each(var key:int in keys)
				{
					g = _id2passPtTable.find(key);
					var passGraphic:Graphic = new Graphic(g.geometry);
					passGraphic.attributes = new Object();
					passGraphic.attributes[_poiDisplayField] = g.attributes[_poiDisplayField];
					stops.features.push(passGraphic);
				}
				
			}
			g = new Graphic(_endGraphic.geometry);
			g.attributes = new Object;
			g.attributes[_poiDisplayField] = _endGraphic.attributes[_poiDisplayField];
			stops.features.push(g);
			routeParams.stops = stops;
			//障碍
			if(_barrierGraphics.length>0)
			{
				routeParams.polygonBarriers = new FeatureSet(_barrierGraphics);
			}
			
			if(_currentSubmitInfo.impedanceType == SubmitInfo.IMPEDANCETYPE_TIME)
			{
				routeParams.impedanceAttribute = timeImpedance;
			}
			else
			{
				routeParams.impedanceAttribute = distanceImpedance;
			}
			
			if(_currentSubmitInfo.noHighWay)
			{
				routeParams.restrictionAttributes = [noHighWayAttrName];
			}
			
			_routeTask.solve(routeParams);
		}
		
		private function routeTask_solveHandler(event:RouteEvent):void
		{
			var naEvent:NAEvent = new NAEvent(NAEvent.EXCUTE_COMPELETE_EVENT);
			naEvent.routeSolveResult = event.routeSolveResult;
			dispatchEvent(naEvent);
		}
		
		private function routeTask_faultHandler(event:FaultEvent):void
		{
			var naEvent:NAEvent = new NAEvent(NAEvent.EXCUTE_FAULT_EVENT);
			naEvent.routeFault = event.fault;
			dispatchEvent(naEvent);
		}
	}
}