package widgets.ToolBar
{
	import widgets.ToolBar.Tools.Clean.Clean;
	import widgets.ToolBar.Tools.Marker.MarkerTool;
	import widgets.ToolBar.Tools.Measure.LineTool;
	import widgets.ToolBar.Tools.Measure.PolygonTool;
	import widgets.ToolBar.Tools.Screenshot.ScreenshotTool;
	import widgets.ToolBar.Tools.Search.SearchCommand;
	import widgets.ToolBar.Tools.navigation.Pan;
	import widgets.ToolBar.Tools.navigation.ZoomIn;
	import widgets.ToolBar.Tools.navigation.ZoomOut;

	/**
	 * 工具栏的工具、命令项注册类，Flex的反射机制必须得把需要的类引用到项目中，
	 * 才能编译到swf里面，所以用这个类对需要反射的对象进行导入
	 **/
	public class ToolCommandImporter
	{
		private var cleanTool:Clean;
		private var markerTool:MarkerTool;
		private var lineTool:LineTool;
		private var polygonTool:PolygonTool;
		private var pan:Pan;
		private var zoomIn:ZoomIn;
		private var zoomOut:ZoomOut;
		private var screenShot:ScreenshotTool;
		private var searchCommand:SearchCommand;
		public function ToolCommandImporter()
		{
		}
	}
}