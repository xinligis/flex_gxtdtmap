package widgets.HorizontalWidgetProxy
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	// these events bubble up from the WidgetListItemRenderer
	[Event(name="widgetListItemClick", type="flash.events.Event")]
	public class WidgetListDataGroup extends DataGroup
	{
		public function WidgetListDataGroup()
		{
			super();
			
			this.itemRenderer = new ClassFactory(WidgetListItemRenderer);
		}
	}
}