package widgets.ToolBar.Tools.navigation
{
	import com.esri.viewer.AppEvent;
	
	import widgets.ToolBar.Tools.BaseTool;
	
	/**
	 * 拉框缩小地图
	 * @author 温杨彪
	 **/
	public class ZoomOut extends BaseTool
	{
		public function ZoomOut()
		{
			super();
		}
		public override function activate(params:Object=null):void
		{
			super.activate(params);
			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "zoomout",status: "Zoom Out"});
		}
		public override function deactivate(params:Object=null):void
		{
			super.deactivate();
			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "pan",status: "pan"});
		}
	}
}