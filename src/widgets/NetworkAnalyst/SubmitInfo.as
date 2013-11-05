package widgets.NetworkAnalyst
{
	public class SubmitInfo
	{
		/**
		 * 时间最短类型
		 **/
		public static const  IMPEDANCETYPE_TIME:String = "time";
		
		/**
		 * 距离最短类型
		 **/
		public static const IMPEDANCETYPE_DISTANCE:String = "distance";
		
		
		/**
		 * 起点名称
		 **/
		public var startName:String;
		/**
		 * 终点名称
		 **/
		public var endName:String;
		
		/**
		 * 途经点的信息
		 * 格式：[{passname:String,passid:int}]
		 **/
		public var passInfos:Array;
		
		/**
		 * 是否有不走高速的限制
		 **/
		public var noHighWay:Boolean = false;
		
		/**
		 * 路网分析的决定类型，IMPEDANCETYPE_TIME（时间最短）和IMPEDANCETYPE_DISTANCE（距离最短）
		 **/
		public var impedanceType:String;
		public function SubmitInfo()
		{
		}
	}
}