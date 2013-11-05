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
	import com.liberty.files.shapefile.Bounds;
	import com.liberty.files.shapefile.content.ShapeFileContentTypes;
	import com.liberty.files.shapefile.content.ShapeFilePolygon;
	
	/**
	 * The ShapeFileUtil class is a utility class inspecting ShapeFile content.
	 * 
	 */	
	public class ShapeFileUtil
	{
		
		/**
		 * Returns the bounds of the ShapeFile, in the raw coordinate system.
		 * @param shapeFile The ShapeFile to inspect.
		 * @return 
		 * 
		 */		
		public static function getMinMaxValues(shapeFile:ShapeFile):Bounds
		{
			var index:int = 0;

			var bounds:Bounds = new Bounds();
			var points:Vector.<Number>;
			var pointsLength:int = 0;
			var shapeFileContent:IShapeFileContent;
			
			for each (var shapeFileRecord:ShapeFileRecord in shapeFile.records)
			{
				shapeFileContent = shapeFileRecord.content;
				
				points = shapeFileContent.getPoints();
				pointsLength = points.length;
				
				for (index = 0; index < pointsLength; index+=2)
				{
					if (points[index] > bounds.maxX)
					{
						bounds.maxX = points[index];
					}
					
					if (points[index] < bounds.minX)
					{
						bounds.minX = points[index];
					}
					
					if (points[index+1] > bounds.maxY)
					{
						bounds.maxY = points[index+1];
					}
					
					if (points[index+1] < bounds.minY)
					{
						bounds.minY = points[index+1];
					}
				}
			}
			
			return bounds;
		}
		
		/**
		 * Determines whether a ShapeFileRecord type is valid.
		 * @param type The type to validate.
		 * @return 
		 * 
		 */		
		public static function isValidRecordType(type:int):Boolean
		{
			return ShapeFileContentTypes.VALID_TYPES.indexOf(type) > -1;
		}
	}
}