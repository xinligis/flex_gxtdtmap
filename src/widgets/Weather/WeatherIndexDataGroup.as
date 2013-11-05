package widgets.Weather
{
	import spark.components.DataGroup;
	import mx.core.ClassFactory;
	public class WeatherIndexDataGroup extends DataGroup
	{
		public function WeatherIndexDataGroup()
		{
			super();
			this.itemRenderer = new ClassFactory(WeatherIndexItemRenderer);
		}
	}
}