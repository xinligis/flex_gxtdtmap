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
	 * Values used for ShapeFile Content Types.
	 * 
	 */	
	public class ShapeFileContentTypes
	{
		/**
		 * The type for multipatch records. 
		 */
		public static const MULTIPATCH:uint = 31;
		
		/**
		 * The type for multipoint records. 
		 */		
		public static const MULTIPOINT:uint = 8;
		
		/**
		 * The type for multipoint m records. 
		 */		
		public static const MULTIPOINT_M:uint = 28;
		
		/**
		 * The type for multipoint z records. 
		 */		
		public static const MULTIPOINT_Z:uint = 18;
		
		/**
		 * The type for null records. 
		 */		
		public static const NULL:uint = 0;
		
		/**
		 * The type for point records. 
		 */		
		public static const POINT:uint = 1;
		
		/**
		 * the type for point m records. 
		 */		
		public static const POINT_M:uint = 21;
		
		/**
		 * The type for point z records. 
		 */		
		public static const POINT_Z:uint = 11;
		
		/**
		 * The type for polyline records. 
		 */		
		public static const POLYLINE:uint = 3;
		
		/**
		 * The type for polyline m records. 
		 */		
		public static const POLYLINE_M:uint = 23;
		
		/**
		 * The type for polyline z records. 
		 */		
		public static const POLYLINE_Z:uint = 13;
		
		/**
		 * The type for polygon records. 
		 */		
		public static const POLYGON:uint = 5;
		
		/**
		 * The type for polygon m records. 
		 */		
		public static const POLYGON_M:uint = 25;
		
		/**
		 * The type for polygon z records. 
		 */		
		public static const POLYGON_Z:uint = 15;
		
		/**
		 * An enumerated array of valid content types. 
		 */		
		public static const VALID_TYPES:Array = [0,1,3,5,8,11,13,15,18,21,23,25,28,31];	
	}
}