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
	/**
	 * The ShapeFilePolylineM class represents Polyline M record type.
	 * 
	 */
	public class ShapeFilePolylineM extends ShapeFilePolyline
	{
		/**
		 * The maximum M (measurement) value. 
		 */	
		public var maxM:Number = 0;
		
		/**
		 * The minimum M (measurement) value. 
		 */	
		public var minM:Number = 0;
		
		/**
		 * A vector of measurement values. 
		 */
		public var mValues:Vector.<Number> = new Vector.<Number>;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ShapeFilePolylineM()
		{
			super();
		}
	}
}