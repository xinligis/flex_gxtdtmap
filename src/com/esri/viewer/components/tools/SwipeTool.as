////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 Esri中国（北京）有限公司
//
// 卷帘针对的图层由一个转变为多层，即针对图层组
// 王红亮，2011-08-112
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.viewer.components.tools
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.tools.BaseTool;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.ResizeEvent;
	import mx.managers.CursorManager;
	
	/**
	 * A swipe tool for map layers.
	 */
	public class SwipeTool extends BaseTool
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a new instance of the swipe tool.
		 * 
		 * @param map Map the toolbar is associated with.
		 */
		/*public function SwipeTool( map:Map = null, layer:Layer = null )
		{
		super(map);
		
		this.layer = layer;
		}
		*/
		public function SwipeTool( map:Map = null, layers:Array = null )
		{
			super(map);
			
			this.layers = layers;
		}
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		// Map click regions
		private static const NONE:int = 0;
		private static const TOP:int = 1;
		private static const LEFT:int = 2;
		private static const RIGHT:int = 3;
		private static const BOTTOM:int = 4;
		private static const TOP_LEFT:int = 5;
		private static const TOP_RIGHT:int = 6;
		private static const BOTTOM_LEFT:int = 7;
		private static const BOTTOM_RIGHT:int = 8;
		
		// Swipe modes
		private static const SWIPE_HORIZONTAL:int = 10;
		private static const SWIPE_VERTICAL:int = 11;
		private static const SWIPE_DIAGONAL_TL:int = 12;
		private static const SWIPE_DIAGONAL_TR:int = 13;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _active:Boolean = false;
		private var _dragging:Boolean = false;
		private var _currentRegion:int = NONE;
		private var _lastMouseLoc:Point;
		
		// Enabled swipe modes
		private var _diagonalSwipeEnabled:Boolean = true;
		
		//private var _layer:Layer; //原有的结构
		//进行掩模的多层图层，王红亮，2011-08-11
		private var _layers:Array;
		//private var _mask:Shape;
		private var _masks:Array;
		// Mouse cursor management
		private var _cursorID:int = -1;
		private var _currentCursor:Class;
		
		[Embed(source="assets/images/swipe/swipe-left.png")]
		private var _swipeLeftIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-right.png")]
		private var _swipeRightIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-up.png")]
		private var _swipeUpIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-down.png")]
		private var _swipeDownIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-down-right.png")]
		private var _swipeDownRightIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-down-left.png")]
		private var _swipeDownLeftIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-up-right.png")]
		private var _swipeUpRightIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-up-left.png")]
		private var _swipeUpLeftIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-horizontal.png")]
		private var _swipeHorizontalIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-vertical.png")]
		private var _swipeVerticalIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-diagonal-tl.png")]
		private var _swipeDiagonalTLIcon:Class;
		
		[Embed(source="assets/images/swipe/swipe-diagonal-tr.png")]
		private var _swipeDiagonalTRIcon:Class;
		
		
		//--------------------------------------------------------------------------
		//  Property:  map
		//--------------------------------------------------------------------------
		
		[Bindable("mapChanged")]
		/**
		 * Map the toolbar is associated with.
		 */
		override public function get map():Map {
			return super.map;
		}
		/**
		 * @private
		 */
		override public function set map( value:Map ):void {
			if (value != super.map) {
				var reactivate:Boolean = active;
				deactivate();
				
				super.map = value;
				
				if (reactivate) {
					activate();
				}
				
				dispatchEvent(new Event("mapChanged"));
			}
		}
		
		//--------------------------------------------------------------------------
		//  Property:  layer
		//--------------------------------------------------------------------------
		
		//[Bindable("layerChanged")]
		/**
		 * The map layer to be swiped with this tool.
		 */
		/*public function get layer():Layer {
		return _layer;
		}
		*/
		/**
		 * @private
		 */
		/*
		public function set layer( value:Layer ):void {
		if (value != _layer) {
		var reactivate:Boolean = active;
		deactivate();
		
		_layer = value;
		
		if (reactivate) {
		activate();
		}
		
		dispatchEvent(new Event("layerChanged"));
		}
		}
		*/
		//--------------------------------------------------------------------------
		//  Property:  layers
		//--------------------------------------------------------------------------
		
		[Bindable("layersChanged")]
		/**
		 * The map layer to be swiped with this tool.
		 */
		public function get layers():Array {
			return _layers;
		}
		/**
		 * @private
		 */
		public function set layers( value:Array ):void {
			if (value != _layers) {
				var reactivate:Boolean = active;
				deactivate();
				
				_layers = value;
				
				if (reactivate) {
					activate();
				}
				
				dispatchEvent(new Event("layersChanged"));
			}
		}
		
		//--------------------------------------------------------------------------
		//  Property:  active
		//--------------------------------------------------------------------------
		
		[Bindable("activate")]
		[Bindable("deactivate")]
		/**
		 * Whether this tool is in the active or inactive state.
		 */
		public function get active():Boolean {
			return _active;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  diagonalSwipeEnabled
		//--------------------------------------------------------------------------
		
		[Bindable]
		[Inspectable(category="Mapping", defaultValue="true")]
		/**
		 * Enables diagonal swiping.
		 * 
		 * @default true
		 */
		public function get diagonalSwipeEnabled():Boolean {
			return _diagonalSwipeEnabled;
		}
		/**
		 * @private
		 */
		public function set diagonalSwipeEnabled( value:Boolean ):void {
			_diagonalSwipeEnabled = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Activates the toolbar for swiping layers.
		 * Activating the toolbar disables map navigation.
		 */
		public function activate():void {
			if (!map || !layers) {
				return;
			}
			if (_active) {
				return;
			}
			_active = true;
			
			map.addEventListener(ResizeEvent.RESIZE, map_onResize, false, 0, true);
			map.addEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown, false, 0, true);
			map.addEventListener(MouseEvent.MOUSE_MOVE, map_onMouseMove, false, 0, true);
			map.addEventListener(MouseEvent.MOUSE_OVER, map_onMouseOver, false, 0, true);
			map.addEventListener(MouseEvent.MOUSE_OUT, map_onMouseOut, false, 0, true);
			
			deactivateMapTools(true, false, false, true, false);
			
			dispatchEvent(new Event("activate"));
		}
		
		/**
		 * Deactivates the toolbar and reactivates map navigation.
		 */
		public function deactivate():void {
			if (!_active) {
				return;
			}
			_active = false;
			_dragging = false;
			_lastMouseLoc = null;
			_currentRegion = NONE;
			
			clearCursor();
			unapplyMask();
			
			if (map) {
				map.removeEventListener(ResizeEvent.RESIZE, map_onResize);
				map.removeEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown);
				map.removeEventListener(MouseEvent.MOUSE_MOVE, map_onMouseMove);
				map.removeEventListener(MouseEvent.MOUSE_UP, map_onMouseUp);
				map.removeEventListener(MouseEvent.MOUSE_OVER, map_onMouseOver);
				map.removeEventListener(MouseEvent.MOUSE_OUT, map_onMouseOut);
			}
			
			activateMapTools(true, false, false, true, false);
			
			dispatchEvent(new Event("deactivate"));
		}
		private function map_onResize( event:ResizeEvent ):void {
			clearCursor();
			
			if (_masks) {
				unapplyMask();
				if (_lastMouseLoc) {
					applyMask(_lastMouseLoc);
				}
			}
		}
		
		private function map_onMouseOver( event:MouseEvent ):void {
			var mousePt:Point = calcMouseLocation(event);
			if (_dragging) {
				setCursor(swipeModeForRegion(_currentRegion));
			} else {
				_currentRegion = getRegion(mousePt);
				setCursor(_currentRegion);
			}
		}
		
		private function map_onMouseOut( event:MouseEvent ):void {
			var mousePt:Point = calcMouseLocation(event);
			clearCursor();
		}
		
		private function map_onMouseDown( event:MouseEvent ):void {
			_dragging = true;
			setCursor(swipeModeForRegion(_currentRegion));
			
			var mousePt:Point = calcMouseLocation(event);
			applyMask(mousePt);
			
			map.removeEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown);
			map.addEventListener(MouseEvent.MOUSE_UP, map_onMouseUp, false, 0, true);
		}
		
		private function map_onMouseUp( event:MouseEvent ):void {
			_dragging = false;
			_lastMouseLoc = null;
			unapplyMask();
			setCursor(_currentRegion);
			
			map.removeEventListener(MouseEvent.MOUSE_UP, map_onMouseUp);
			map.addEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown, false, 0, true);
		}
		
		private function map_onMouseMove( event:MouseEvent ):void {
			var mousePt:Point = calcMouseLocation(event);
			if (_dragging) {
				updateMask(mousePt);
			} else {
				var newRegion:int = getRegion(mousePt);
				if (newRegion != _currentRegion) {
					_currentRegion = newRegion;
					setCursor(_currentRegion);
				}
			}
		}
		
		/**
		 * Returns the mouse pixel location in map local coordinate space.
		 * Updates the cached last mouse position.
		 */
		private function calcMouseLocation( event:MouseEvent ):Point {
			var pt:Point = map.globalToLocal(new Point(event.stageX, event.stageY));
			_lastMouseLoc = pt;
			return pt;
		}
		
		/**
		 * Returns the region of the map in which the specified mouse location lies.
		 * The mouse point must be in pixel coordinates within the map coordinate space.
		 */
		private function getRegion( mousePt:Point ):int {
			const w:Number = map.width;
			const h:Number = map.height;
			const x:Number = mousePt.x;
			const y:Number = mousePt.y;
			
			if (w <= 0 || h <= 0) {
				return NONE;
			}
			// Prevent divide-by-zero errors
			if (x == 0) {
				return LEFT;  // somewhat arbitrary fallback value
			}
			
			// Diagonal check
			if (diagonalSwipeEnabled) {
				if (x < w * 0.25) {
					if (y < h * 0.25) {
						return TOP_LEFT;
					} else if (y > h * 0.75) {
						return BOTTOM_LEFT;
					}
				} else if (x > w * 0.75) {
					if (y < h * 0.25) {
						return TOP_RIGHT;
					} else if (y > h * 0.75) {
						return BOTTOM_RIGHT;
					}
				}
			}
			
			// Horizontal and vertical check
			var sm:Number = h / w;
			var sp:Number = y / x;
			var nsp:Number = (h - y) / x;
			if (sp < sm) {
				if (nsp < sm) {
					return RIGHT;
				} else {
					return TOP;
				}
			} else {
				if (nsp < sm) {
					return BOTTOM;
				} else {
					return LEFT;
				}
			}
			
			return NONE;
		}
		
		private function applyMask( mousePt:Point ):void {
			if (_currentRegion == NONE) {
				return;
			}
			//王红亮，2011-08-11
			if(!_layers)
			{
				return;
			}
			if(_masks)
			{
				return;
			}
			//王红亮，2011-08-11，为每一层生成一个mask
			_masks = [];
			for each(var lyr:Layer in _layers) 
			{
				const w:Number = map.width / Math.abs(map.scaleX);
				const h:Number = map.height / Math.abs(map.scaleY);
				const x:Number = mousePt.x;
				const y:Number = mousePt.y;
				const xy:Number = x + y;
				
				var mask:Shape = new Shape();
				var g:Graphics = mask.graphics;
				g.clear();
				g.beginFill(0x000000);
				
				// Render the mask based on the clicked region and the current mouse position
				switch (_currentRegion) {
					case LEFT:
						g.drawRect(x, 0, w - x, h);
						break;
					case TOP:
						g.drawRect(0, y, w, h - y);
						break;
					case RIGHT:
						g.drawRect(0, 0, x, h);
						break;
					case BOTTOM:
						g.drawRect(0, 0, w, y);
						break;
					case TOP_LEFT:
						g.moveTo(w, h);
						if (xy <= h) {
							g.lineTo(0, h);
							g.lineTo(0, xy);
						} else {
							g.lineTo(xy - h, h);
						}
						if (xy <= w) {
							g.lineTo(xy, 0);
							g.lineTo(w, 0);
						} else {
							g.lineTo(w, xy - w);
						}
						g.lineTo(w, h);
						break;
					case BOTTOM_RIGHT:
						g.moveTo(0, 0);
						if (xy <= w) {
							g.lineTo(xy, 0);
						} else {
							g.lineTo(w, 0);
							g.lineTo(w, xy - w);
						}
						if (xy <= h) {
							g.lineTo(0, xy);
						} else {
							g.lineTo(xy - h, h);
							g.lineTo(0, h);
						}
						g.lineTo(0, 0);
						break;
					case TOP_RIGHT:
						g.moveTo(0, h);
						if (x < y) {
							g.lineTo(0, y - x);
						} else {
							g.lineTo(0, 0);
							g.lineTo(x - y, 0);
						}
						if (w - x < h - y) {
							g.lineTo(w, y + w - x);
							g.lineTo(w, h);
						} else {
							g.lineTo(x + h - y, h);
						}
						g.lineTo(0, h);
						break;
					case BOTTOM_LEFT:
						g.moveTo(w, 0);
						if (w - x < h - y) {
							g.lineTo(w, y + w - x);
						} else {
							g.lineTo(w, h);
							g.lineTo(x + h - y, h);
						}
						if (x < y) {
							g.lineTo(0, y - x);
							g.lineTo(0, 0);
						} else {
							g.lineTo(x - y, 0);
						}
						g.lineTo(w, 0);
						break;
				}
				
				g.endFill();
				_masks.push(mask);
				// Add the mask to the display list, using rawChildren since Map extends Container
				map.addChild(mask);
				
				// Apply the mask to the target layer
				//layer.mask = _mask;
				lyr.mask = mask;
			}
		}
		
		private function updateMask( mousePt:Point ):void {
			unapplyMask();
			applyMask( mousePt );
		}
		
		private function unapplyMask():void {
			/*
			if (layer) {
				// Unmask the target layer
				layer.mask = null;
			}
			*/
			if(layers)
			{
				for each(var lyr:Layer in layers)
				{
					lyr.mask = null;
				}
			}
			/*
			if (_mask) {
				if (map) {
					// Remove the mask from the display list, using rawChildren since Map extends Container
					try {
						map.removeChild(_mask);
					} catch (e:Error) {}
				}
				_mask = null;
			}
			*/
			//王红亮，2011-08-11
			if (!_masks)
			{
				return;
			}
			if (!map)
			{
				return;
			}
			// Remove the mask from the display list, using rawChildren since Map extends Container
			for each(var mask:Shape in _masks)		
			{
				try	{
					map.removeChild(mask);
				}
				catch (e:Error) {}
				mask = null;
			}
			_masks = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Cursor management methods
		//
		//--------------------------------------------------------------------------
		
		private function setCursor( mode:int ):void
		{
			var cursor:Class = cursorIconForMode(mode);
			if (cursor) {
				if (cursor !== _currentCursor) {
					clearCursor();
					_currentCursor = cursor;
					_cursorID = CursorManager.setCursor(cursor);
				}
			} else {
				clearCursor();
			}
		}
		
		private function clearCursor():void
		{
			if (_currentCursor) {
				CursorManager.removeCursor(_cursorID);
				_cursorID = -1;
				_currentCursor = null;
			}
		}
		
		private function cursorIconForMode( mode:int ):Class
		{
			switch (mode) {
				case LEFT:
					return _swipeRightIcon;
				case RIGHT:
					return _swipeLeftIcon;
				case TOP:
					return _swipeDownIcon;
				case BOTTOM:
					return _swipeUpIcon;
				case TOP_LEFT:
					return _swipeDownRightIcon;
				case TOP_RIGHT:
					return _swipeDownLeftIcon;
				case BOTTOM_LEFT:
					return _swipeUpRightIcon;
				case BOTTOM_RIGHT:
					return _swipeUpLeftIcon;
				case SWIPE_HORIZONTAL:
					return _swipeHorizontalIcon;
				case SWIPE_VERTICAL:
					return _swipeVerticalIcon;
				case SWIPE_DIAGONAL_TL:
					return _swipeDiagonalTLIcon;
				case SWIPE_DIAGONAL_TR:
					return _swipeDiagonalTRIcon;
			}
			return null;
		}
		
		private function swipeModeForRegion( region:int ):int
		{
			switch (region) {
				case LEFT:
				case RIGHT:
					return SWIPE_HORIZONTAL;
				case TOP:
				case BOTTOM:
					return SWIPE_VERTICAL;
				case TOP_LEFT:
				case BOTTOM_RIGHT:
					return SWIPE_DIAGONAL_TL;
				case TOP_RIGHT:
				case BOTTOM_LEFT:
					return SWIPE_DIAGONAL_TR;
			}
			return NONE;
		}
	}
	
}