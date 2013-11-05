package widgets.NewInfowindow
{
	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	public class InfoContentDataGroup extends DataGroup
	{
		public function InfoContentDataGroup()
		{
			super();
			itemRenderer = new ClassFactory(InfoContentItemRenderer);
		}
	}
}