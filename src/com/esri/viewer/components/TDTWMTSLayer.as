////////////////////////////////////////////////////////////////////////////
//天地图的WMTS接入的API
//Esri china(beijing) 2012
//2012-02-27
/////////////////////////////////////////////////////////////////////////
package com.esri.viewer.components
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.Units;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.ags.layers.supportClasses.LOD;
	import com.esri.ags.layers.supportClasses.TileInfo;
	
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;
	
	public class TDTWMTSLayer extends TiledMapServiceLayer
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var url:String;
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		// 这三个属性，需要根据服务的具体内容进行设定
		//--------------------------------------------------------------------------
		public var style:String = "default";
		public var layer:String = "vec";
		public var tileMatrixSet:String = "c";
		public var format:String = "tiles";
		//----------------------------------
		//  fullExtent
		//----------------------------------
		
		private var _fullExtent:Extent = new Extent(-180,-90,180,90, new SpatialReference(4326));
		
		/**
		 * @private
		 */
		override public function get fullExtent():Extent
		{
			return _fullExtent;
		}
		
		public function TDTWMTSLayer(url:String = null)
		{
			super();
			this.url = url;
			buildTileInfo(); // to create hardcoded tileInfo
			
			setLoaded(true); // Map will only use loaded layers
		}
		//----------------------------------
		//  initialExtent
		//----------------------------------
		
		private var _initialExtent:Extent = new Extent(
			-180,-90,180,90,
			new SpatialReference(4326));
		
		/**
		 * @private
		 */
		override public function get initialExtent():Extent
		{
			return _initialExtent;
		}
		
		//----------------------------------
		//  spatialReference
		//----------------------------------
		
		private var _spatialReference:SpatialReference = new SpatialReference(4326);
		
		/**
		 * Returns a SpatialReference with a wkid value of 3857.
		 */
		override public function get spatialReference():SpatialReference
		{
			return _spatialReference;
		}
		
		//----------------------------------
		//  tileInfo
		//----------------------------------
		
		private var _tileInfo:TileInfo = new TileInfo();
		
		/**
		 * @private
		 */
		override public function get tileInfo():TileInfo
		{
			return _tileInfo;
		}
		
		//----------------------------------
		//  units
		//----------------------------------
		
		/**
		 * Returns Units.METERS
		
		override public function get units():String
		{
			return Units.DECIMAL_DEGREES;
		}
		 */
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
		{
			var url:String = this.url.replace("{d}", String(Math.round(Math.random() * 6) + 1))
				+ "?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile" + "&FORMAT=" + format 
				+ "&TILEMATRIXSET=" + tileMatrixSet
				+ "&STYLE=" + style
				+ "&LAYER=" + layer
				+ "&TILEMATRIX=" + level
				+ "&TILEROW=" + row
				+ "&TILECOL=" + col;
			return new URLRequest(url);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function buildTileInfo():void
		{
			_tileInfo.dpi = 90.71428571427429;
			_tileInfo.spatialReference = new SpatialReference(4326);
			_tileInfo.height = 256;
			_tileInfo.width = 256;
			_tileInfo.format = format;
			_tileInfo.origin = new MapPoint(-180, 90.0);
			_tileInfo.lods =
				[
					new LOD(1, 0.703125, 2.9549759305875003E8),
					new LOD(2, 0.3515625, 1.4774879652937502E8),
					new LOD(3, 0.17578125, 7.387439826468751E7),
					new LOD(4, 0.087890625, 3.6937199132343754E7),
					new LOD(5, 0.0439453125, 1.8468599566171877E7),
					new LOD(6, 0.02197265625, 9234299.783085939),
					new LOD(7, 0.010986328125, 4617149.891542969),
					new LOD(8, 0.0054931640625, 2308574.9457714846),
					new LOD(9, 0.00274658203125, 1154287.4728857423),
					new LOD(10, 0.001373291015625, 577143.7364428712),
					new LOD(11, 6.866455078125E-4, 288571.8682214356),
					new LOD(12, 3.4332275390625E-4, 144285.9341107178),
					new LOD(13, 1.71661376953125E-4, 72142.9670553589),
					new LOD(14, 8.58306884765625E-5, 36071.48352767945),
					new LOD(15, 4.291534423828125E-5, 18035.741763839724),
					new LOD(16,2.1457672119140625E-5, 9017.870881919862),
					new LOD(17,1.0728836059570312E-5, 4508.935440959931),
					new LOD(18,0.536441802978516e-5, 2254.4677204799655),
					new LOD(19,0.26822090148925781e-5, 1127.2338602399827),
					new LOD(20,1.3411045074462891e-6, 563.61693011999137)
				];
		}
	}
}