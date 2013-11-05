package widgets.ToolBar.Tools.Measure
{
	public class MeasureUtil
	{
		public function MeasureUtil()
		{
		}
		
		public static function StringReplaceAll(source:String, find:String, replacement:String ):String
		{
			return source.split( find ).join( replacement ); 
		}
	}
}