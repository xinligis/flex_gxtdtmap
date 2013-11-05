package widgets.HotSpot
{
	import com.esri.ags.geometry.Extent;

	public class HotSpotItem
	{
		/**
		 * 热点区域的名字
		 **/
		public var name:String;
		/**
		 * 热点区域的范围
		 **/
		public var extent:Extent;
		/**
		 * 热点区域的缩略图地址
		 **/
		public var imageUrl:String;
		public function HotSpotItem()
		{
		}
	}
}