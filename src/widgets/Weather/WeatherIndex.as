package widgets.Weather
{
	import flash.events.EventDispatcher;
	/**
	 * 天气预报中的指数（如穿衣指数）信息
	 * @author 王红亮，2012-4-20
	 */
	[Bindable]
	public class WeatherIndex extends EventDispatcher
	{
		/**
		 * 指数的名称，如穿衣
		 */
		public var name:String;
		/**
		 * 指数的性质，如适宜
		 */
		public var value:String;
		/**
		 * 详细描述，如天气较冷，适合穿长袖
		 */
		public var description:String;
		public function WeatherIndex()
		{
			name = "";
			value = "";
			description = "";
		}
	}
}