package widgets.IPLocation
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	// these events bubble up from the SearchResultItemRenderer
	//[Event(name="provinceClick", type="flash.events.Event")]
	
	public class ProvinceDataGroup extends DataGroup
	{
		public function ProvinceDataGroup()
		{
			super();
			this.itemRenderer = new ClassFactory(ProvinceItemRenderer);
		}
	}
}