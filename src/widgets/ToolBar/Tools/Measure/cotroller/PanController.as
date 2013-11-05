package widgets.ToolBar.Tools.Measure.cotroller
{
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import spark.components.BorderContainer;

	public class PanController
	{
		private var _map:Map
		
		private var _isPan:Boolean;
		private var _currentDirection:int;
		
		private var _panHandler:uint;
		
		public function PanController(map:Map)
		{
			_map=map;
		}
		
		public function start():void
		{
			_map.panDuration=50;
			_map.addEventListener(MouseEvent.MOUSE_MOVE,map_mouseMoverHandler);
		}
		
		public function stop():void
		{
			_map.panDuration=300;
			_map.removeEventListener(MouseEvent.MOUSE_MOVE,map_mouseMoverHandler);
		}
		
		private function map_mouseMoverHandler(event:MouseEvent):void
		{
			
			var pt:MapPoint=_map.toMapFromStage(event.stageX,event.stageY);
			var extent:Extent=_map.extent;
			
			if(pt.x<(extent.xmin+extent.width/100))
			{
				//left 0
//				trace("left");
				startPan(0);
			}
			
			
			
			else if(pt.x>(extent.xmax-extent.width/100))
			{
				//right 1
//				trace("right");
				startPan(1);
			}
			
			else if(pt.y>(extent.ymax-extent.height/100))
			{
				//top 2
//				trace("top")
				startPan(2);
			}
			else if(pt.y<(extent.ymin+extent.height/100))
			{
				//bottom 3
//				trace("bottom")
				startPan(3);
			}
			else if(_isPan)
			{
//				trace("stop")
				stopPan();
			}
		}
		
		private function startPan(direction:int):void
		{
			if(direction == _currentDirection)
				return;
			stopPan();
			_currentDirection=direction;
			_isPan=true;
			setTimeout(function():void
			{
				_panHandler=setInterval(pan,60,direction);
			},50);
		}
		
		
		private function pan(direction:int):void
		{
			var extent:Extent = _map.extent;
			switch(direction)
			{
				case 0://left
					extent = extent.offset(-extent.width/100,0);
				break;
				case 1://right
					extent = extent.offset(extent.width/100,0);
					break;
				case 2://top
					extent = extent.offset(0,extent.width/100);
					break;
				case 3:
					extent = extent.offset(0,-extent.width/100);
					break;
			}
			_map.extent=extent;
		}
		
		private function stopPan():void
		{
			clearInterval(_panHandler);
			_isPan=false;
			_currentDirection=-1;
		}
		
	}
}