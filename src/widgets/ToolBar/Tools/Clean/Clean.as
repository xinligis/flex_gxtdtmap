package widgets.ToolBar.Tools.Clean
{
	import widgets.ToolBar.Tools.BaseCommand;
	
	public class Clean extends BaseCommand
	{
		public function Clean()
		{
			super();
		}
		
		public override function excute(params:Object=null):void
		{
			graphicsLayer.clear();
			super.excute(params);
		}
	}
}