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
	
	/**
	 * WMTSLayer
	 */
	public class WMTSLayer extends TiledMapServiceLayer
	{
		public function WMTSLayer()
		{
			super();
			
			buildTileInfo(); // to create hardcoded tileInfo
			
			setLoaded(true); // Map will only use loaded layers
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var url:String;

		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  fullExtent
		//----------------------------------
		
		private var _fullExtent:Extent = new Extent(
			-197.99999999999991, -98.68020782884993, 198.0, 92.28436187585005,
			new SpatialReference(4326));
		
		/**
		 * @private
		 */
		override public function get fullExtent():Extent
		{
			return _fullExtent;
		}
		
		//----------------------------------
		//  initialExtent
		//----------------------------------
		
		private var _initialExtent:Extent = new Extent(
			114.72996909922944, 39.33600936430017, 117.91408356277071, 41.200283635699975,
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
		
		private var _spatialReference:SpatialReference = new SpatialReference(3857);
		
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
			var url:String = this.url
				+ "?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile" + "&LAYER=BeijingMap" + "&STYLE=_null" + "&FORMAT=image/png24" + "&TILEMATRIXSET=EPSG:4326"
				+ "&TILEMATRIX=EPSG:4326:" + level
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
			_tileInfo.format = "image/png24";
			_tileInfo.origin = new MapPoint(-180.0, 90.0);
			_tileInfo.lods =
				[
					new LOD(0, 0.0027465820243834883, 1154287.47),
					new LOD(1, 0.0013732910240890493, 577143.74),
					new LOD(2, 6.866455120445247E-4, 288571.87),
					new LOD(3, 3.4332274412495725E-4, 144285.93),
					new LOD(4, 1.7166138395978368E-4, 72142.97),
					new LOD(5, 8.583068008258681E-5, 36071.48),
					new LOD(6, 4.291534004129341E-5, 18035.74),
					new LOD(7, 2.1457670020646703E-5, 9017.87),
					new LOD(8, 1.0728846907628379E-5, 4508.94)
				];
		}
	}
}