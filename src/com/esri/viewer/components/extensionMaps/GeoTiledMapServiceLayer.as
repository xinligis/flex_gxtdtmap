package com.esri.viewer.components.extensionMaps
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.ags.layers.supportClasses.LOD;
	import com.esri.ags.layers.supportClasses.TileInfo;
	import com.esri.viewer.components.extensionMaps.TiledRequest;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import mx.utils.StringUtil;
	
	public class GeoTiledMapServiceLayer extends TiledMapServiceLayer
	{
		public var tileRequest:TiledRequest = null;
		
		public function GeoTiledMapServiceLayer(initialExtent:Extent)
		{
			super();
			_initialExtent = initialExtent;
			buildTileInfo(); // to create our hardcoded tileInfo		
			setLoaded(true); // Map will only use loaded layers
		}
		private var _tileInfo:TileInfo = new TileInfo(); // see buildTileInfo()
		//各级别服务的名称，王红亮添加，2011-02-15
		//private var _serviceNames:Array;
		private var _initialExtent:Extent;
		private var _baseURL:String;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//      fullExtent()
		//      initialExtent()
		//      spatialReference()
		//      tileInfo()
		//      units()
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  fullExtent
		//  - required to calculate the tiles to use
		//----------------------------------
		
		override public function get fullExtent():Extent
		{
			return new Extent(-180,-90,180,90, new SpatialReference(4326));
		}
		
		//----------------------------------
		//  initialExtent
		//  - needed if Map doesn't have an extent
		//  u can set the intialExtent by the xmin,ymin,xmax,ymax
		//----------------------------------
		
		override public function get initialExtent():Extent
		{
			return _initialExtent;
		}
		
		//----------------------------------
		//  spatialReference
		//  - needed if Map doesn't have a spatialReference
		//----------------------------------
		
		override public function get spatialReference():SpatialReference
		{
			return new SpatialReference(4326);
		}
		
		//----------------------------------
		//  tileInfo
		//----------------------------------
		
		override public function get tileInfo():TileInfo
		{			return _tileInfo;
		}
		
		//----------------------------------
		//  units
		//  - needed if Map doesn't have it set
		//----------------------------------
		/**
		override public function get units():String
		{
			return "esriDecimalDegrees";
		}
		**/
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//      getTileURL(level:Number, row:Number, col:Number):URLRequest
		// 王红亮，esirchina(Beijing),编辑于2011-02-15
		//--------------------------------------------------------------------------
		
		override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
		{
			// Use virtual cache directory
			// This assumes the cache's virtual directory is exposed, which allows you access
			// to tile from the Web server via the public cache directory.
			// Example of a URL for a tile retrieved from the virtual cache directory:
			// http://serverx.esri.com/arcgiscache/dgaerials/Layers/_alllayers/L01/R0000051f/C000004e4.jpg
			if(tileRequest)
				return tileRequest.getURLRequest(level, row, col);
			else
				return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function buildTileInfo():void
		{
			//_resolution = 0.70312500000011879;    //**************** 根据天地图的实际地址修改  调节系数    *************//
			_tileInfo.height = 256;
			_tileInfo.width = 256;
			_tileInfo.origin = new MapPoint(-180, 90);
			_tileInfo.spatialReference = new SpatialReference(4326);
			_tileInfo.lods = new Array();
			_tileInfo.lods =
				[
//					new LOD(0, 0.703125, 2.9549759306e8),
//					new LOD(1, 0.3515625, 1.4774879653e8),
//					new LOD(2, 0.17578125, 7.387439826e7),
//					new LOD(3, 0.087890625, 3.693719913e7),
//					new LOD(4, 0.0439453125, 1.846859957e7),
//					new LOD(5, 0.02197265625, 9234299.78),
//					new LOD(6, 0.010986328125, 4617149.89),
//					new LOD(7, 0.0054931640625, 2308574.95),
//					new LOD(8, 0.00274658203125, 1154287.47),
//					new LOD(9, 0.001373291015625, 577143.74),
//					new LOD(10, 0.0006866455078125, 288571.87),
//					new LOD(11, 3.4332275390625e-4, 144285.93),
//					new LOD(12, 1.71661376953125e-4, 72142.97),
//					new LOD(13, 8.58306884765625e-5, 36071.48),
//					new LOD(14, 4.291534423828125e-5, 18035.74),
//					new LOD(15,2.145767211914063e-5, 9017.87),
//					new LOD(16,1.072883605957032e-5, 4508.94)
					new LOD(0, 0.703125, 2.9549759305875003E8),
					new LOD(1, 0.3515625, 1.4774879652937502E8),
					new LOD(2, 0.17578125, 7.387439826468751E7),
					new LOD(3, 0.087890625, 3.6937199132343754E7),
					new LOD(4, 0.0439453125, 1.8468599566171877E7),
					new LOD(5, 0.02197265625, 9234299.783085939),
					new LOD(6, 0.010986328125, 4617149.891542969),
					new LOD(7, 0.0054931640625, 2308574.9457714846),
					new LOD(8, 0.00274658203125, 1154287.4728857423),
					new LOD(9, 0.001373291015625, 577143.7364428712),
					new LOD(10, 6.866455078125E-4, 288571.8682214356),
					new LOD(11, 3.4332275390625E-4, 144285.9341107178),
					new LOD(12, 1.71661376953125E-4, 72142.9670553589),
					new LOD(13, 8.58306884765625E-5, 36071.48352767945),
					new LOD(14, 4.291534423828125E-5, 18035.741763839724),
					new LOD(15,2.1457672119140625E-5, 9017.870881919862),
					new LOD(16,1.0728836059570312E-5, 4508.935440959931),
//					new LOD(17,0.536441802978516e-5, 2254.4677204799655),
//					new LOD(18,0.26822090148925781e-5, 1127.2338602399827),
//					new LOD(19,1.3411045074462891e-6, 563.61693011999137)
					//					new LOD(17,0.536441802978516e-5, 2257.00)
					
				];
		}
		
		//--------------------------------------------------------------------------
		//
		//  服务名称属性
		// 王红亮添加，2011-02-15
		//--------------------------------------------------------------------------
		/*public function set serviceNames(names:Array):void
		{
			if(_serviceNames == null)
				_serviceNames = new Array(names.length);
			for(var index:uint = 0; index < names.length; ++index)
			{
				_serviceNames[index] = names[index];
			}
		}
		*/
	}
}

