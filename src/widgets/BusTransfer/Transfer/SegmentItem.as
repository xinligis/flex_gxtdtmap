package widgets.BusTransfer.Transfer
{
	import com.esri.ags.Graphic;
	import com.esrichina.publictransportation.Segment;
	
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.elements.TextFlow;
	[Bindable]
	public class SegmentItem extends EventDispatcher
	{
		public var index:int;
		public var description:TextFlow;
		/**
		 * 该段起始站点的graphic
		 */
		public var graphic:Graphic;
		/**
		 * wayDetail结果中segments中对应的segment对象
		 */
		public var segment:Segment;
	}
}