package widgets.ToolBar.ui
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.viewer.ConfigData;
	
	import mx.collections.ArrayCollection;

	public class ToolBarItem
	{
		public  static const TOOL_TYPE:String="tool";
		public  static const COMMAND_TYPE:String="command";
		
		/**
		 * 是否分组
		 **/
		public var isGroup:Boolean;
		
		/**
		 * 图标
		 **/
		[Bindable]
		public var icon:Object;
		
		/**
		 * 类路径
		 **/
		public var classpath:String;
		
		/**
		 * 标题
		 **/
		[Bindable]
		public var label:String;
		
		/**
		 * 激活状态
		 **/
		public var activated:Boolean;
		
		/**
		 * 类型
		 **/
		public var type:String;
		
		/**
		 * 项
		 **/
		[Bindable]
		public var items:ArrayCollection;
		
		/**
		 * 与之关联的地图
		 **/
		public var map:Map;
		
		/**
		 * graphicsLayer
		 **/
		public var graphicsLayer:GraphicsLayer;
		
		/**
		 * 配置文件地址
		 **/
		public var config:String;
		
		/**
		 * 之前是否有分割线
		 **/
		[Bindable]
		public var spacer:Boolean;
		
		/**
		 * 鼠标样式
		 **/
		public var cursor:Class;
		
		[Bindable]
		public var tooltip:String;
		
		/**
		 * 全局配置
		 **/
		public var configData:ConfigData;
	}
}