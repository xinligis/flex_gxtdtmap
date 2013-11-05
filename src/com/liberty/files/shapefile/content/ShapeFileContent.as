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
package com.liberty.files.shapefile.content
{
	import com.liberty.files.shapefile.IShapeFileContent;
	
	import flash.geom.Rectangle;
	
	/**
	 * The ShapeFileContent class is the base class for all drawable map content.
	 * 
	 */	
	public class ShapeFileContent implements IShapeFileContent
	{
		/**
		 * The bounds of the ShapeFileContent. 
		 */		
		public var bounds:Rectangle;
		
		/**
		 * The number of parts in the ShapeFileContent. 
		 */		
		public var numParts:uint = 0;
		
		/**
		 * The number of points in the ShapeFileContent. 
		 */		
		public var numPoints:uint = 0;
		
		/**
		 * The vector of parts in the ShapeFileContent. 
		 */		
		public var parts:Vector.<int> = new Vector.<int>;
		
		/**
		 * The vector of points in the ShapeFileContent. 
		 */		
		public var points:Vector.<Number> = new Vector.<Number>;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ShapeFileContent()
		{
			
		}
		
		/**
		 * Returns the parts vector. 
		 * @return 
		 * 
		 */		
		public function getParts():Vector.<int>
		{
			return parts;
		}
		
		/**
		 * Returns the points vector. 
		 * @return 
		 * 
		 */		
		public function getPoints():Vector.<Number>
		{
			return points;
		}
	}
}