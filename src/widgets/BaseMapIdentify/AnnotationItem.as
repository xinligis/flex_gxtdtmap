package widgets.BaseMapIdentify
{
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.symbols.PictureMarkerSymbol;
	import com.esri.viewer.utils.Hashtable;

	public class AnnotationItem
	{
		/**
		 * 注记类图层的服务地址
		 **/
//		public var url:String;
		/**
		 * 注记图层中与之关联的实际要素ID的字段名
		 */
		public var featureIdFieldName:String;
		/**
		* 输出的字段数组
		**/
		public var outFields:Array;
		/**
		 * 注记图层关联的实际要素图层的服务地址
		 **/
		public var relateUrl:String;
		
		/**
		 * 显示注记的featurelayer
		 **/
		public var featureLayer:FeatureLayer;
		
		/**
		 * infowindow上显示的标题的字段
		 **/
		public var titlefield:String;
		
		/**
		 * POI的类型字段
		 **/
		public var typefield:String = "";
		
		/**
		 * infowindow上显示的详细信息的字段
		 **/
		public var linkfield:String;
		public function AnnotationItem()
		{
		}
		
		/**
		 * 高亮符号
		 **/
		public var defultHeighlightSymbol:PictureMarkerSymbol;
		
		/**
		 * 不同类型POI对应的高亮symbol
		 **/
		public var type2heighlightSymbolTable:Hashtable;
	}
}