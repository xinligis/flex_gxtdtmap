package widgets.ToolBar.Tools.navigation
{
	import com.esri.viewer.AppEvent;
	
	import widgets.ToolBar.Tools.BaseTool;
	
	/**
	 * 平移地图
	 * @author 温杨彪
	 **/
	public class Pan extends BaseTool
	{
		public function Pan()
		{
			super();
		}
		public override function activate(params:Object=null):void
		{
			super.activate(params);
//			AppEvent.dispatch(AppEvent.SET_MAP_NAVIGATION, {tool: "pan",status: "Pan"});
		}
	}
}