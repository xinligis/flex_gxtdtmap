package widgets.BusTransfer.Transfer
{
	import com.esrichina.publictransportation.Segment;
	
	import flash.events.EventDispatcher;
		
	import mx.collections.ArrayCollection;

	/**
	 * 界面显示的一条完整的换乘方案，数据类
	 */
	[Bindable]
	public class TransferItem extends EventDispatcher
	{
		/**
		 * 方案的序号
		 */
		public var index:int;
		/**
		 * 换乘的线路信息
		 */
		public var transfers:String;
		/**
		 * 总耗时，单位分钟
		 */
		public var timeCost:int;
		/**
		 * 该换乘方案的一般信息，总站数、总距离、换乘次数等
		 */
		public var generalInfo:String;
		/**
		 * 起点名称
		 */
		public var startName:String;
		/**
		 * 从出发地到达第一个公交站点的步行段
		 */
		public var firstWalkSegment:Segment;
		/**
		 * 详细的公交乘坐描述集合
		 */
		public var segments:ArrayCollection;
		/**
		 * 终点的名称
		 */
		public var endName:String;
	}
}