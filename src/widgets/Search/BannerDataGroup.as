package widgets.Search
{
	import mx.core.ClassFactory;
	import spark.components.DataGroup;
	
	[Event(name="bannerClick", type="flash.events.Event")]
	
	public class BannerDataGroup extends DataGroup
	{
		public function BannerDataGroup()
		{
			super();
			
			this.itemRenderer = new ClassFactory(BannerItemRenderer);
		}
	}
}