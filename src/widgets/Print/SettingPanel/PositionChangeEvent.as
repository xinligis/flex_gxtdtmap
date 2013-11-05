package widgets.Print.SettingPanel
{
	import flash.events.Event;
	
	public class PositionChangeEvent extends Event
	{
		public static const DIRECTION_UP:String="up";
		public static const DIRECTION_DOWN:String="down";
		public static const DIRECTION_RIGHT:String="right";
		public static const DIRECTOIN_LEFT:String="left";
		
		public static const DIRECTION_HORIZONTAL_CENTER:String="horizontalcenter";
		public static const DIRECTION_VERTICAL_CENTER:String="verticalcenter";
		
		public static const DIRECTION_CENTER:String="center";
		
		public static const STEP_SMALL:String="small";
		public static const STEP_LARGE:String="large";
		
		
		public var direction:String;
		public var stepType:String;
		
		public function PositionChangeEvent(direction:String,steptype:String)
		{
			super("positionChange");
			this.direction=direction;
			this.stepType=steptype;
		}
	}
}