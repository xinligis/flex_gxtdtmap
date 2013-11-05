package widgets.ToolBar.Tools.navigation
{
	import com.esri.viewer.AppEvent;
	
	import widgets.ToolBar.Tools.BaseTool;
	
	/**
	 * 拉框放大地图
	 * @author 温杨彪
	 **/
	public class ZoomIn extends BaseTool
	{
		public function ZoomIn()
		{
			super();
		}
		public override function activate(params:Object=null):void
		{
			super.activate(params);
			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "zoomin",status: "Zoom In"});
		}
		public override function deactivate(params:Object=null):void
		{
			super.deactivate();
			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "pan",status: "pan"});
		}
	}
}