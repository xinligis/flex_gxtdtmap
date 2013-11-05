package widgets.Weather
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Bindable]
	/**
	 * 城市的天气预报信息
	 */
	public class CityWeather extends EventDispatcher
	{
		/**
		 * 该城市对应的行政pac
		 */
		public var pac:String;
		public var name:String;
		/**
		 * 天气预报服务网中该城市的标识
		 */
		public var cityId:String;
		/**
		 * 天气符号显示的位置
		 */
		public var graphic:Graphic;
		/**
		 * 对应的天气信息
		 */
		public var weatherInfo:WeatherInfo;
		/**
		 * 从WeatherInfo中提取出的当天的天气符号
		 */
		public var weatherIcon:String;
		/**
		 * 当天的温度信息，最低-最高温度
		 */
		public var temprature:String;
		public function CityWeather(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}