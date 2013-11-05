package widgets.NetworkAnalyst
{
	public class ValidInfo
	{
		/**
		 * 不确定的起点类型
		 **/
		public static const INVALID_TYPE_START:String = "start";
		/**
		 * 不确定的终点类型
		 **/
		public static const INVALID_TYPE_END:String = "end";
		/**
		 * 不确定的途经点类型
		 **/
		public static const INVALID_TYPE_PASS:String = "pass";
		
		/**
		 * 不确定的类型，起点、终点和途经点
		 **/
		public var invalidType:String;
		/**
		 * 不确定的名字
		 **/
		public var invalidName:String;
		public function ValidInfo()
		{
		}
	}
}