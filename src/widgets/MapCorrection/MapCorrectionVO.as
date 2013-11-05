package widgets.MapCorrection
{
	import com.esri.ags.geometry.Geometry;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	[RemoteClass(alias="com.esrichina.portal.flex.pojo.MapCorrection")]
	public class MapCorrectionVO extends EventDispatcher
	{
//		public var infoType:String; //纠错信息类型，包括：地点和道路
//		public var errorType:String; //错误类型，包括：位置错误，名称错误和其他
//		public var geometryType:Geometry;//(包括点，线)
//		public var correctionName:String;//纠错后的名称
//		public var PAC:String;//所属的区域
//		public var meomoType:String;//描述信息
//		public var pictureType:Object;//上传图片文件
//		public var name:String;//纠错人的姓名
//		public var phoneNum:String;//纠错人的电话
//		public var emailNum:String;//纠错人的邮箱
		
		/**
		 * 纠错信息id
		 **/
		public var errmsgid:int;
		
		/**
		 * 纠错信息类型，包括：地点和道路
		 **/
		public var msgType:String;
		/**
		 * 错误类型
		 **/
		public var errType:String;
		
		/**
		 * 空间信息，以[类型(String)，原(String),纠错(String)，类型(String),原(String)，纠错(String),.....,]
		 * 的格式存放。所有空间数据均由com.esri.ags.utils.JSON.encode(geometry)方法转成String后传给后台。
		 **/
		public var geometrys:Array;
		
	
		/**
		 * 纠错名称
		 **/
		public var name:String;
		
		/**
		 * 所属区域pac码
		 **/
		public var pac:String;
		
		public var admin:String;
		
		/**
		 * 描述信息
		 **/
		public var description:String;
		
		/**
		 * 上传的图片文件
		 **/
		public var picture:ByteArray;
		
		/**
		 * 纠错人的姓名
		 **/
		public var author:String;
		
		/**
		 * 纠错人的电话
		 **/
		public var tel:String;
		/**
		 * 纠错人的邮箱
		 **/
		public var email:String;
		
		/**
		 * 审核状态，"0"未审核,"1"已审核
		 */
		public var state:String;
		
		/**
		 * 纠错人的Id
		 **/
		public var authorId:Number;
		
		/**
		 * 纠错信息创建的时间
		 **/
		public var createdate:Date;
	}
}