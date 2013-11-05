package widgets.Print.SettingPanel
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	
	
	[Event(name="compassItemClick", type="flash.events.Event")]
	[Event(name="compassItemMouseOver", type="flash.events.Event")]
	[Event(name="compassItemMouseOut", type="flash.events.Event")]
	public class CompassDataGroup extends DataGroup
	{
		public function CompassDataGroup()
		{
			super();
			this.itemRenderer=new ClassFactory(CompassItemRenderer);
		}
	}
}