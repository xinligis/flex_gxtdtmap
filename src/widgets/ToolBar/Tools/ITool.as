package widgets.ToolBar.Tools
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.viewer.ConfigData;
	

	/**
	 * 所有工具条上的工具都必须实现ITool接口，工具是与地图有互动的
	 * @author 温杨彪 2012-1-11
	 * 
	 **/
	public interface ITool
	{
		/**
		 * 与工具绑定的地图
		 **/
		function set map(value:Map):void;
		
		/**
		 * 与工具绑定的地图
		 **/
		function get map():Map;
		
		/**
		 * 激活工具
		 * @params 传入的参数
		 **/
		function activate(params:Object=null):void;
		
		/**
		 * 释放工具
		 * @params 传入的参数
		 **/
		function deactivate(params:Object=null):void;
		
		/**
		 * 工具是否处于激活状态
		 **/
		function get activated():Boolean;
		
		/**
		 * 设置激活时的回调方法
		 * @handler 回调的方法，格式为：function handler(tool:ITool)
		 **/
		function set activateHandler(handler:Function):void;
		
		/**
		 * 设置释放时的回调方法
		 * @handler 回调的方法，格式为：function handler(tool:ITool)
		 **/
		function set deactivateHandler(handler:Function):void;
		
		/**
		 * 设置工具的配置信息
		 * @value 配置信息，从工具的config.xml中获取
		 **/
		function set configXML(value:XML):void;
		
		/**
		 * 得到工具的配置信息
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
		 * 工具的显示标签
		 **/
		function set toolLabel(value:String):void;
		
		/**
		 * 工具的显示标签
		 **/
		function get toolLabel():String;
		
		/**
		 * 工具激活时的光标
		 **/
		function get toolCursor():Class;
		
		/**
		 * 工具激活时的光标
		 **/
		function set toolCursor(value:Class):void;
		
		/**
		 * 工具的tooltip
		 **/
		function get tooltip():String;
		
		/**
		 * 工具的tooltip
		 **/
		function set tooltip(value:String):void;
		
		/**
		 * 激活或者执行工具条上的其他工具或者命令的回调方法
		 **/
		function set activeOtherToolorCommandHandler(value:Function):void;
		
		/**
		 * 激活或者执行工具条上的其他工具或者命令的回调方法
		 **/
		function get activeOtherToolorCommandHandler():Function;
		
		/**
		 * 工具在激活期间需要运行其他的widget的回调方法
		 **/
		function set runWidgetHandler(value:Function):void;
		
		/**
		 * 工具在激活期间需要运行其他的widget的回调方法
		 **/
		function get runWidgetHandler():Function;
		
		/**
		 * 工具在激活期间需要向viewer框架发送POSTPROCESS消息，Function的参数为(msgType:String[消息类型],data:Object[包含的数据])
		 **/
		function set postProcessHandler(value:Function):void;
		
		/**
		 * 工具在激活期间需要向viewer框架发送POSTPROCESS消息，Function的参数为(msgType:String[消息类型],data:Object[包含的数据])
		 **/
		function get postProcessHandler():Function;
		
		/**
		 * viewer的全局配置信息
		 **/
		function get configData():ConfigData;
		
		/**
		 * viewer的全局配置信息
		 **/
		function set configData(value:ConfigData):void;
	}
}