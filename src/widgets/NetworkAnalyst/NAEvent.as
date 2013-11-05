package widgets.NetworkAnalyst
{
	import com.esri.ags.Graphic;
	import com.esri.ags.tasks.supportClasses.RouteSolveResult;
	import com.esri.viewer.components.sho.ui.CompletionInput;
	
	import flash.events.Event;
	
	import mx.rpc.Fault;
	
	
	public class NAEvent extends Event
	{
		/**
		 * 查询Graphic事件
		 **/
		public static const QUERY_GRAPHIC_EVENT:String = "queryGraphic";
		
		/**
		 * 用户输入提示查询事件
		 **/
		public static const ASSET_WORDS_QUERY_EVENT:String = "assetWordQuery";
		
		/**
		 * 画Graphic事件
		 **/
		public static const DRAW_GRAPHIC_EVENT:String = "drawGraphic";
		
		/**
		 * 删除途经点事件
		 **/
		public static const DELETE_PASS_GRAPHIC_EVENT:String = "deletePassGraphic";
		
		/**
		 * 重置输入参数并清除结果事件
		 **/
		public static const RESET_AND_CLEANALL_EVENT:String = "resetAndCleanAll";
		
		/**
		 * 提交处理请求事件
		 **/
		public static const SUBMIT_EVENT:String = "submit";
		
		/**
		 * 验证起点事件
		 **/
		public static const VALID_START_EVENT:String = "validStart";
		
		/**
		 * 验证终点事件
		 **/
		public static const VALID_END_EVENT:String = "validEnd";
		
		/**
		 * 验证途经点事件
		 **/
		public static const VALID_PASS_EVENT:String = "validPass";
		
		/**
		 * 开始执行网络分析事件
		 **/
		public static const START_EXCUTE_EVENT:String = "startExcute";
		
		/**
		 * 执行网络分析完成事件
		 **/
		public static const EXCUTE_COMPELETE_EVENT:String = "excuteCompelete";
		
		/**
		 * 执行网络分析失败事件
		 **/
		public static const EXCUTE_FAULT_EVENT:String = "excuteFault";
		
		/**
		 * 有下拉提示的输入框
		 **/
		public var completionInput:CompletionInput;
		/**
		 * 有下拉提示的输入框中用户输入的文字信息
		 **/
		public var inputPrefix:String;
		
		/**
		 * 用于查询的Graphic
		 **/
		public var queryGraphic:Graphic;
		
		/**
		 * 查询Graphic的类型，起点、终点或者途经点。
		 **/
		public var queryGraphicType:String;
		
		/**
		 * 画的Graphic的类型，起点、终点、途经点或者障碍
		 **/
		public var drawType:String;
		
		/**
		 * 画的Graphic
		 **/
		public var drawGraphic:Graphic;
		
		/**
		 * 删除的途经点的ID
		 **/
		public var deletePassGraphicId:int;
		
		/**
		 * 网络分析提交时输入Panel的信息
		 **/
		public var submitInfo:SubmitInfo;
		
		/**
		 * 验证输入的信息
		 **/
		public var validInfo:ValidInfo;
		
		/**
		 * 路网分析结果
		 **/
		public var routeSolveResult:RouteSolveResult;
		
		/**
		 * 路径分析失败信息
		 **/
		public var routeFault:Fault;
		
		public function NAEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}