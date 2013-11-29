package widgets.Weather
{
	[RemoteClass(alias="com.esrichina.portal.flex.pojo.Weather")]
	
	import flash.events.EventDispatcher;
	/**
	 * 天气预报信息类
	 * 王红亮，2012-4-20
	 */
	public class WeatherInfo extends EventDispatcher
	{
		/**
		 * 穿衣指数
		 **/
		public static const INFOTYPE_DRESSING:String="dessing";
		
		/**
		 * 感冒指数
		 **/
		public static const INFOTYPE_COLD:String="cold";
		
		/**
		 * 空气污染指数
		 **/
		public static const INFOTYPE_AIR:String = "air";
		
		/**
		 * 晾晒指数
		 **/
		public static const INFOTYPE_DRYING:String = "drying";
		
		/**
		 * 路况指数
		 **/
		public static const INFOTYPE_TRAFIC:String = "trafic";
		
		/**
		 * 旅游指数
		 **/
		public static const INFOTYPE_TRAVEL:String = "travel";
		
		/**
		 * 舒适度指数
		 **/
		public static const INFOTYPE_COZY:String="cozy";
		
		/**
		 * 洗车指数
		 **/
		public static const INFOTYPE_CARWASH:String="carwash";
		
		/**
		 * 运动指数
		 **/
		public static const INFOTYPE_SPORT:String="sport";
		
		/**
		 * 紫外线指数
		 **/
		public static const INFOTYPE_UV:String="uv";
		public static const weatherNames:Array = ["晴","多云","阴","阵雨","雷阵雨","雷阵雨伴有冰雹","雨夹雪","小雨","中雨","大雨","暴雨","大暴雨","特大暴雨","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小雨-中雨","中雨-大雨","大雨-暴雨","暴雨-大暴雨","大暴雨-特大暴雨","小雪-中雪","中雪-大雪","大雪-暴雪","浮尘","扬沙","强沙尘暴"];
		public var cityName:String;
		public var cityId:String;
		public var currentDate:Array; // year,month,day
		/**
		 * 今后几天的天气，已编码表示，0表示晴，参见weatherNames数组定义
		 */
		public var weathers:Array; 
		public var maxtempratures:Array;// 今后几天的最高气温,数字类型
		public var mintempratures:Array;// 今后几天的最低气温,数字类型
		public var wind:Array;// 今后几天的风向风力描述，字符型
		public var humidity:Array;// 今后几天的湿度百分比 
		public var ultravioletRays:Array; // 今后几天的紫外线强度；
		public var dessingIndex:String;// 穿衣指数
		public var dessing:String;// 穿衣描述
		public var coldIndex:String;// 感冒指数
		public var cold:String;// 感冒描述
		public var airIndex:String;// 空气污染指数
		public var air:String;// 空气污染描述
		public var dryingIndex:String;// 晾晒指数
		public var drying:String;// 晾晒指数描述
		public var traficIndex:String; // 路况指数
		public var trafic:String; // 路况指数描述
		public var travelIndex:String; // 旅游指数
		public var travel:String; // 旅游指数描述
		public var cozyIndex:String;// 舒适度指数
		public var cozy:String;// 舒适度指数描述
		public var carwashIndex:String;// 洗车指数；
		public var carwash:String;// 洗车指数描述；
		public var sportIndex:String;// 运动指数；
		public var sport:String;// 运动指数描述；
		public var uvIndex:String; // 紫外线指数
		public var uv:String; // 紫外线指数描述
	}
}