package widgets.ToolBar
{
	import flash.events.Event;
	
	/**
	 * 通知工具栏，执行其他已加载到工具条上的工具
	 * @author 温杨彪 2012-1-16
	 **/
	public class ExcuteEvent extends Event
	{
		public static const Excute:String="ExcuteEvent";
		public var classpath:String;
		public var params:Object;
		public function ExcuteEvent(classpath:String,params:Object)
		{
			super(Excute, true);
			this.classpath=classpath;
			this.params=params;
		}
	}
}