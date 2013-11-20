package widgets.Search
{
	public class LayerObject
	{
		public function LayerObject()
		{
		}
		public var url:String; //url
		public var titlefield:String; //标题
		public var outFields:Array;	//返回结果字段数组
		public var outFieldAlias:Array; //返回结果字段别名
		public var catalogmatch:String;	//大类查询表达式
		public var subcatalogmatch:String; //小类查询表达式
	}
}