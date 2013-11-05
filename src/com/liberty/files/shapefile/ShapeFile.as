/*

LibertyGIS - LibertyGIS is an open source flex mapping framework for displaying ShapeFiles.

http://code.google.com/p/liberty-gis/

Copyright (c) 2010 - 2012 Bryan Dresselhaus, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package com.liberty.files.shapefile
{
	import com.liberty.files.shapefile.ShapeFileParser;
	import com.liberty.files.shapefile.ShapeFileUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.IMXMLObject;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when content loading is complete.
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *  Dispatched when a network request is made over HTTP 
	 *  and Flash Player or AIR can detect the HTTP status code.
	 * 
	 *  @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 *  Dispatched when an input/output error occurs.
	 *  @see flash.events.IOErrorEvent
	 *
	 *  @eventType flash.events.IOErrorEvent.IO_ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 *  Dispatched when a network operation starts.
	 * 
	 *  @eventType flash.events.Event.OPEN
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 *  Dispatched when content is loading.
	 *
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 *  Dispatched when a security error occurs while content is loading.
	 *  For more information, see the SecurityErrorEvent class.
	 *
	 *  @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	[Bindable]
	/**
	 * The ShapeFile class represents a geographical ShapeFile data structure.
	 *
	 * @includeExample ShapeFileExample.mxml
	 */
	public class ShapeFile implements IMXMLObject, IEventDispatcher
	{
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The bounds of the ShapeFile, in projected coordindates (latitude / longitude, meters) 
		 */		
		public var bounds:Rectangle;
		
		/**
		 * The code of the ShapeFile. 
		 */		
		public var code:uint = 0;
		
		/**
		 * @private 
		 */		
		private var dispatcher:EventDispatcher;
		
		/**
		 * The length, in bytes, of the ShapeFile.
		 */		
		public var length:uint = 0;
		
		/**
		 * The m value of the ShapeFile. 
		 */		
		public var m:Point;

		/**
		 * An array of records in the ShapeFile. 
		 */		
		public var records:Array = new Array();
		
		/**
		 * The bounds of the ShapeFile, in x y coordinates. 
		 */		
		public var shapeFileBounds:Bounds = new Bounds();
		
		/**
		 * The Type of the ShapeFile. 
		 */		
		public var type:uint = 0;
		
		/**
		 * The version of the ShapeFile. 
		 */		
		public var version:uint = 0;
		
		/**
		 * The z value of the ShapeFile. 
		 */		
		public var z:Point;
		
		//----------------------------------
		//  bytesLoaded (read only)
		//----------------------------------
		
		/**
		 * @private 
		 */		
		private var _bytesLoaded:Number = NaN;
		
		[Bindable("progress")]	
		/**
		 *  The number of bytes of the dbf file already loaded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		//----------------------------------
		//  bytesTotal (read only)
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the bytesTotal property.
		 */
		private var _bytesTotal:Number = NaN;
		
		[Bindable("complete")]
		/**
		 *  The total size of the dbf file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		//----------------------------------
		//  percentLoaded (read only)
		//----------------------------------
		
		[Bindable("progress")]
		/**
		 *  The percentage of the image or SWF file already loaded.
		 *
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get percentLoaded():Number
		{
			var p:Number = isNaN(_bytesTotal) || _bytesTotal == 0 ? 0 : 100 * (_bytesLoaded / _bytesTotal);
			
			if (isNaN(p))
			{
				p = 0;
			}
			
			return p;
		}
		
		//----------------------------------
		//  source
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the source property.
		 */
		private var _source:Object;
		
		[Bindable("sourceChanged")]
		[Inspectable(category="General", defaultValue="", format="File")]
		/**
		 * The URL, ByteArray, Class to load as the content.  
		 * 
		 */		
		public function get source():Object
		{
			return _source;
		}
		
		/**
		 * @private
		 * 
		 */		
		public function set source(value:Object):void
		{	
			if (_source == value)
			{
				return;
			}
			
			_bytesLoaded = _bytesTotal = 0;
			
			records = [];
			
			_source = value;
			
			loadContent(value);
		}
		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ShapeFile()
		{
			dispatcher = new EventDispatcher();
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * @inherited
		 * 
		 */		
		public function initialized(document:Object, id:String):void
		{
			
		}
		
		/**
		 * @private
		 * 
		 */		
		private function loadContent(value:Object):void
		{
			var byteArray:ByteArray;
			
			if (value is Class)
			{
				var cls:Class = Class(value);
				
				parseByteArray(new cls() as ByteArray);
			}
			else if (value is ByteArray)
			{
				byteArray = ByteArray(value);
				
				_bytesLoaded = _bytesTotal = ByteArray(value).bytesAvailable;
				
				parseByteArray(value as ByteArray);
			}
			else if (value is String)
			{
				var urlRequest:URLRequest = new URLRequest(value.toString());
				var urlLoader:URLLoader = new URLLoader();
				
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				
				urlLoader.addEventListener(Event.COMPLETE, onURLLoaderComplete, false, 0, true);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onURLLoaderHTTPStatusEvent, false, 0, true);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onURLLoaderIOErrorEvent, false, 0, true);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, onURLLoaderProgress, false, 0, true);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLLoaderSecurityErrorEvent, false, 0, true);
				
				urlLoader.load(urlRequest);
			}
		}
		
		/**
		 * Parses a ByteArray into a ShapeFile instance.
		 * @param byteArray
		 * 
		 */		
		public function parseByteArray(byteArray:ByteArray):void
		{
			byteArray.position = 0;
			
			ShapeFileParser.parseHeader(byteArray, this);
			ShapeFileParser.parseRecords(byteArray, this);
			
			var newBounds:Bounds = new Bounds();
			
			newBounds.maxX = bounds.width;
			newBounds.minX = bounds.x;
			newBounds.maxY = bounds.height;
			newBounds.minY = bounds.y;
			
			shapeFileBounds = newBounds;
		}
		
		/**
		 * Shifts ShapeFile latitude values by 360 degrees. 
		 * @param minimum The minimum threshhold limit for shifting values.
		 * @param maximum The maximum threshhold limit for shifting values.
		 * 
		 */		
		public function shiftLatitude(minimum:Number, maximum:Number):void	
		{
			var length:int = 0;
			var points:Vector.<Number>;
			
			for each (var shapeFileRecord:ShapeFileRecord in records)
			{
				points = shapeFileRecord.content.getPoints();
				length = points.length;
				
				for (var index:int = 0; index < length; index++)
				{
					if (! Boolean(index % 2 == 0))
					{
						if (points[index] >= minimum && points[index] <= maximum)
						{
							points[index] -= 360;
						}
					}
				}
			}
			
			shapeFileBounds = ShapeFileUtil.getMinMaxValues(this);
		}
		
		/**
		 * Shifts ShapeFile longitude values by 360 degrees. 
		 * @param minimum The minimum threshhold limit for shifting values.
		 * @param maximum The maximum threshhold limit for shifting values.
		 * 
		 */		
		public function shiftLongitude(minimum:Number, maximum:Number):void	
		{
			var length:int = 0;
			var points:Vector.<Number>;
			
			for each (var shapeFileRecord:ShapeFileRecord in records)
			{
				points = shapeFileRecord.content.getPoints();
				length = points.length;
				
				for (var index:int = 0; index < length; index++)
				{
					if (index % 2 == 0)
					{
						if (points[index] >= minimum && points[index] <= maximum)
						{
							points[index] += 360;
						}
					}
				}
			}
			
			shapeFileBounds = ShapeFileUtil.getMinMaxValues(this);
		}
		
		//--------------------------------------
		//  IEventDispatcher methods
		//--------------------------------------
		
		/**
		 * @private
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		/**
		 * @private 
		 * @param evt
		 * @return 
		 * 
		 */		
		public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		/**
		 * @private 
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * @private 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @private 
		 * @param type
		 * @return 
		 * 
		 */		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		//--------------------------------------
		//  Event Handlers
		//--------------------------------------
		
		/**
		 * @private 
		 * @param event
		 * 
		 */		
		private function onURLLoaderComplete(event:Event):void
		{
			parseByteArray(URLLoader(event.currentTarget).data as ByteArray);
			
			_bytesLoaded = URLLoader(event.currentTarget).bytesLoaded;
			_bytesTotal = URLLoader(event.currentTarget).bytesTotal;
			
			dispatchEvent(event);
		}
		
		/**
		 * @private 
		 * @param event
		 * 
		 */		
		private function onURLLoaderHTTPStatusEvent(event:HTTPStatusEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private 
		 * @param event
		 * 
		 */		
		private function onURLLoaderIOErrorEvent(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * @private 
		 * @param event
		 * 
		 */		
		private function onURLLoaderProgress(event:ProgressEvent):void
		{
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			
			dispatchEvent(event);
		}
		
		/**
		 * @private 
		 * @param event
		 * 
		 */		
		private function onURLLoaderSecurityErrorEvent(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
	}
}