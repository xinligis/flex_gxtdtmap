package widgets.ClosestFacility
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.Symbol;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class ClosestFacilityResult extends EventDispatcher
	{
		//infopopup 中使用
		public var icon:String;
				
		public var title:String;
		
		public var symbol:Symbol;
		
		public var content:String;
		
		public var point:MapPoint;
		
		public var link:String;
		
		public var geometry:Geometry;
		
		public var graphic:Graphic;
		
		public var route:Graphic;
		
		public var totalTime:String;
		
		public var totalDistance:String;
	}
}