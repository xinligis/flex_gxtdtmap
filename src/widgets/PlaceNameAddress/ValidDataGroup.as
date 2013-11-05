package  widgets.PlaceNameAddress
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;

	/**
	 * 选择POI事件
	 **/
	[Event(name="itemSelect",type="flash.events.Event")]
	public class ValidDataGroup extends DataGroup
	{
		public function ValidDataGroup()
		{
			super();
			itemRenderer = new ClassFactory(ValidItemRenderer);
		}
	}
}