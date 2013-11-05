package widgets.ToolBar.Tools
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	
	/**
	 * 所有工具条上的命令都必须实现ICommand接口，命令与地图没有互动
	 * @author 温杨彪
	 **/
	public interface ICommand
	{
		/**
		 * 与命令绑定的地图
		 **/
		function set map(value:Map):void;
		
		/**
		 * 与命令绑定的地图
		 **/
		function get map():Map;
		
		/**
		 * 设置命令的配置信息
		 * @value 配置信息，从命令的config.xml中获取
		 **/
		function set configXML(value:XML):void;
		
		/**
		 * 获取命令的配置信息
		 **/
		function get configXML():XML;
		
		/**
		 * 得到ToolBar的所有工具与命令共享的GraphicsLayer
		 **/
		function get graphicsLayer():GraphicsLayer;
		
		/**
		 * 设置ToolBar的所有工具与命令共享的GraphicsLayer
		 **/
		function set graphicsLayer(value:GraphicsLayer):void;
		
		/**
		 * 命令执行后的回调方法
		 * @param value 回调方法，格式为function handler(tool:ICommand)
		 **/
		function set excuteHandler(value:Function):void;
		
		/**
		 * 执行命令
		 * @params 传入的参数
		 **/
		function excute(params:Object=null):void;
		
		/**
		 * 是否要运行Widget
		 **/
		function get isRunWidget():Boolean;
		
		/**
		 * 运行的Widget的url
		 **/
		function get widgetUrl():String;
		
		function set commandLabel(value:String):void;
		
		function get commandLabel():String;
		
		/**
		 * 命令需要向viewer框架发送POSTPROCESS消息，Function的参数为(msgType:String[消息类型],data:Object[包含的数据])
		 **/
		function set postProcessHandler(value:Function):void;
		
		/**
		 * 命令需要向viewer框架发送POSTPROCESS消息，Function的参数为(msgType:String[消息类型],data:Object[包含的数据])
		 **/
		function get postProcessHandler():Function
	}
}