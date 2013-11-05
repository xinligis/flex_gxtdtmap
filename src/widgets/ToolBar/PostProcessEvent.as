package widgets.ToolBar
{
	import flash.events.Event;
	
	/**
	 * 工具或者命令向viewer框架发送post process消息
	 * @author 温杨彪 ；2012-2-9
	 **/
	public class PostProcessEvent extends Event
	{
		public static const SENDPOSTPROCESS:String="SendPostProcess";
		public var messageType:String;
		public var data:Object;
		public function PostProcessEvent(messageType:String,data:Object)
		{
			super(SENDPOSTPROCESS, true, false);
			this.messageType=messageType;
			this.data=data;
		}
	}
}