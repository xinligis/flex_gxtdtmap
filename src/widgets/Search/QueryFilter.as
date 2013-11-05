/**
 * 类文件名：QueryFilter.as
 * 作者：温杨彪
 * 描述：查询的过滤条件
 * 版本信息：1.0
 * 创建时间：2012-09-17
 *  Copyright (c) 2010-2011 ESRI China (Beijing) Ltd. All rights reserved
 * 版权所有
 **/
package widgets.Search
{
	import com.esri.ags.geometry.Geometry;

	/**
	 * 查询的过滤条件
	 **/
	public class QueryFilter
	{
		/**
		 * 查询url
		 **/
		public var url:String; 
		/**
		 * 当前选中的城市xml,district:当前的区县xml
		 **/
		public var city:Object = null;
		/**
		 * 几何范围在viewport和custom下有效
		 **/
		public var geometry:Geometry = null;
		/**
		 * POI大类Code
		 **/
		public var poiCatalogCode:String = "";
		
		/**
		 * POI小级Code
		 **/
		public var subPOICatalogCode:String = "";
		/**
		 * 阻止此次查询的个数，如当在当前视域下查询后，因点击结果列表使结果居中而导致地图范围变化，此数值将加一。
		 **/
//		public var preventers:int;
		/**
		 * 查询的关键字
		 **/
		public var keyword:String = "";
		
		/**
		 * 需要查询的IDs
		 **/
		public var oids:Array = [];
		
		/**
		 * 输出字段
		 **/
		public var outFields:Array = [];
		
		public function QueryFilter()
		{
		}
	}
}