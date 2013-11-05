package widgets.ClosestFacility
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	// these events bubble up from the QueryResultItemRenderer
	[Event(name="closestFacilityResultClick", type="flash.events.Event")]
	[Event(name="closestFacilityResultMouseOver", type="flash.events.Event")]
	[Event(name="closestFacilityResultMouseOut", type="flash.events.Event")]
	
	public class ClosestFacilityResultDataGroup extends DataGroup
	{
		public function ClosestFacilityResultDataGroup()
		{
			super();
			
			this.itemRenderer = new ClassFactory(ClosestFacilityResultItemRenderer);
		}
	}
}