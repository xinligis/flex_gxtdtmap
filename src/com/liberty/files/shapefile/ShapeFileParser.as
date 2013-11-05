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
	import com.liberty.files.shapefile.content.ShapeFileContent;
	import com.liberty.files.shapefile.content.ShapeFileContentTypes;
	import com.liberty.files.shapefile.content.ShapeFileMultiPoint;
	import com.liberty.files.shapefile.content.ShapeFilePoint;
	import com.liberty.files.shapefile.content.ShapeFilePolygon;
	import com.liberty.files.shapefile.content.ShapeFilePolygonM;
	import com.liberty.files.shapefile.content.ShapeFilePolygonZ;
	import com.liberty.files.shapefile.content.ShapeFilePolyline;
	import com.liberty.files.shapefile.content.ShapeFilePolylineM;
	import com.liberty.files.shapefile.content.ShapeFilePolylineZ;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * The ShapeFileParser class is for parsing ShapeFile binary data into ShapeFile instances.
	 * 
	 * @see com.libert.files.shapefile.ShapeFile
	 */	
	public class ShapeFileParser
	{
		/**
		 * Parses the header of a ShapeFile. 
		 * @param byteArray The ByteArray to parse the header from.
		 * @param shapeFile The ShapeFile to store the header information in.
		 * 
		 */			
		public static function parseHeader(byteArray:ByteArray, shapeFile:ShapeFile):void
		{
			byteArray.endian = Endian.BIG_ENDIAN;
			
			shapeFile.code = byteArray.readUnsignedInt();
			
			byteArray.position = 24;
			
			shapeFile.length = byteArray.readUnsignedInt();
			
			byteArray.endian = Endian.LITTLE_ENDIAN;
			
			shapeFile.version = byteArray.readUnsignedInt();
			
			shapeFile.type = byteArray.readUnsignedInt();
			
			shapeFile.bounds = new Rectangle(byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble());
			
			shapeFile.z = new Point(byteArray.readDouble(), byteArray.readDouble());
			shapeFile.m = new Point(byteArray.readDouble(), byteArray.readDouble());
		}
		
		
		/**
		 * Parses a MultiPoint record from a ByteArray. 
		 * @param byteArray The ByteArray containing the Point record.
		 * @return 
		 * 
		 */	
		private static function parseMultiPoint(byteArray:ByteArray):ShapeFileMultiPoint
		{
			var shapeFileMultiPoint:ShapeFileMultiPoint = new ShapeFileMultiPoint();
			
			var index:int = 0;
			
			shapeFileMultiPoint.bounds = new Rectangle(byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble());
			
			shapeFileMultiPoint.numPoints = byteArray.readUnsignedInt();
			
			for (index = 0; index < shapeFileMultiPoint.numPoints; index++)
			{
				shapeFileMultiPoint.points.push(byteArray.readDouble());
				shapeFileMultiPoint.points.push(byteArray.readDouble());
			}
			
			return shapeFileMultiPoint;
		}
		/**
		 * Parses a Parts and Points from a ByteArray. 
		 * @param byteArray The ByteArray containing the parts and points.
		 * @return 
		 * 
		 */
		private static function parsePartsPoints(byteArray:ByteArray, shapeFileContent:ShapeFileContent):void
		{
			var index:int = 0, n:int = 0;
			
			shapeFileContent.bounds = new Rectangle(byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble(), byteArray.readDouble());
			
			shapeFileContent.numParts = byteArray.readUnsignedInt();
			shapeFileContent.numPoints = byteArray.readUnsignedInt();
			
			for (index = 0; index < shapeFileContent.numParts; index++)
			{
				shapeFileContent.parts.push(byteArray.readUnsignedInt());
			}
			
			for (index = 0; index < shapeFileContent.numPoints; index++)
			{
				shapeFileContent.points.push(byteArray.readDouble());
				shapeFileContent.points.push(byteArray.readDouble());
			}
		}
		
		/**
		 * Parses a Point record from a ByteArray. 
		 * @param byteArray The ByteArray containing the Point record.
		 * @return 
		 * 
		 */	
		private static function parsePoint(byteArray:ByteArray):ShapeFilePoint
		{
			var shapeFilePoint:ShapeFilePoint = new ShapeFilePoint();
			
			shapeFilePoint.points.push(byteArray.readDouble());
			shapeFilePoint.points.push(byteArray.readDouble());
			
			return shapeFilePoint;
		}
		
		/**
		 * Parses a Polygon record from a ByteArray. 
		 * @param byteArray The ByteArray containing the Polygon record.
		 * @return 
		 * 
		 */		
		private static function parsePolygon(byteArray:ByteArray):ShapeFilePolygon
		{
			var shapeFilePolygon:ShapeFilePolygon = new ShapeFilePolygon();
			
			parsePartsPoints(byteArray, shapeFilePolygon);
			
			return shapeFilePolygon;
		}
		
		/**
		 * Parses a PolygonM record from a ByteArray.
		 * @param byteArray The ByteArray containing the PolygonM record.
		 * @return 
		 * 
		 */
		private static function parsePolygonM(byteArray:ByteArray):ShapeFilePolygonM
		{
			var shapeFilePolygonM:ShapeFilePolygonM = new ShapeFilePolygonM();
			
			parsePartsPoints(byteArray, shapeFilePolygonM);
			
			shapeFilePolygonM.minM = byteArray.readDouble();
			shapeFilePolygonM.maxM = byteArray.readDouble();
			
			for (var index:int = 0; index < shapeFilePolygonM.numPoints; index++)
			{
				shapeFilePolygonM.mValues.push(byteArray.readDouble());
			}
			
			return shapeFilePolygonM;
		}
		
		/**
		 * Parses a PolygonZ record from a ByteArray.
		 * @param byteArray The ByteArray containing the PolygonZ record.
		 * @return 
		 * 
		 */
		private static function parsePolygonZ(byteArray:ByteArray):ShapeFilePolygonZ
		{
			var shapeFilePolygonZ:ShapeFilePolygonZ = new ShapeFilePolygonZ();
			
			parsePartsPoints(byteArray, shapeFilePolygonZ);
			
			shapeFilePolygonZ.minZ = byteArray.readDouble();
			shapeFilePolygonZ.maxZ = byteArray.readDouble();
			
			for (index = 0; index < shapeFilePolygonZ.numPoints; index++)
			{
				shapeFilePolygonZ.zValues.push(byteArray.readDouble());
			}
			
			shapeFilePolygonZ.minM = byteArray.readDouble();
			shapeFilePolygonZ.maxM = byteArray.readDouble();
			
			for (var index:int = 0; index < shapeFilePolygonZ.numPoints; index++)
			{
				shapeFilePolygonZ.mValues.push(byteArray.readDouble());
			}
			
			return shapeFilePolygonZ;
		}
		
		/**
		 * Parses a Polyline record from a ByteArray. 
		 * @param byteArray The ByteArray containing the Polyline record.
		 * @return 
		 * 
		 */
		private static function parsePolyline(byteArray:ByteArray):ShapeFilePolyline
		{			
			var shapeFilePolyline:ShapeFilePolyline = new ShapeFilePolyline();
			
			parsePartsPoints(byteArray, shapeFilePolyline);
			
			return shapeFilePolyline;
		}
		
		/**
		 * Parses a PolylineM record from a ByteArray. 
		 * @param byteArray The ByteArray containing the PolylineM record.
		 * @return 
		 * 
		 */
		private static function parsePolylineM(byteArray:ByteArray):ShapeFilePolylineM
		{
			var shapeFilePolylineM:ShapeFilePolylineM = new ShapeFilePolylineM();
			
			parsePartsPoints(byteArray, shapeFilePolylineM);
			
			shapeFilePolylineM.minM = byteArray.readDouble();
			shapeFilePolylineM.maxM = byteArray.readDouble();
			
			for (var index:int = 0; index < shapeFilePolylineM.numPoints; index++)
			{
				shapeFilePolylineM.mValues.push(byteArray.readDouble());
			}
			
			return shapeFilePolylineM;
		}
		
		/**
		 * Parses a PolylineZ record from a ByteArray. 
		 * @param byteArray The ByteArray containing the PolylineZ record.
		 * @return 
		 * 
		 */
		private static function parsePolylineZ(byteArray:ByteArray):ShapeFilePolylineZ
		{
			var index:int = 0;
			
			var shapeFilePolylineZ:ShapeFilePolylineZ = new ShapeFilePolylineZ();
			
			parsePartsPoints(byteArray, shapeFilePolylineZ);
			
			shapeFilePolylineZ.minZ = byteArray.readDouble();
			shapeFilePolylineZ.maxZ = byteArray.readDouble();
			
			for (index = 0; index < shapeFilePolylineZ.numPoints; index++)
			{
				shapeFilePolylineZ.zValues.push(byteArray.readDouble());
			}
			
			shapeFilePolylineZ.minM = byteArray.readDouble();
			shapeFilePolylineZ.maxM = byteArray.readDouble();
			
			for (index = 0; index < shapeFilePolylineZ.numPoints; index++)
			{
				shapeFilePolylineZ.mValues.push(byteArray.readDouble());
			}
			
			return shapeFilePolylineZ;
		}
		
		/**
		 * Parses records from a ByteArray. 
		 * @param byteArray The ByteArray to parse the records from.
		 * @param shapeFile The ShapeFile to store the records in.
		 * 
		 */		
		public static function parseRecords(byteArray:ByteArray, shapeFile:ShapeFile):void
		{
			var shapeFileRecord:ShapeFileRecord;
			
			while (byteArray.bytesAvailable)
			{	
				shapeFileRecord = new ShapeFileRecord();
				
				byteArray.endian = Endian.BIG_ENDIAN;
				
				shapeFileRecord.recordNumber = byteArray.readUnsignedInt();

				shapeFileRecord.recordLength = byteArray.readUnsignedInt();
				
				byteArray.endian = Endian.LITTLE_ENDIAN;
				
				shapeFileRecord.type = byteArray.readUnsignedInt();
				
				// We've reached an invalid record, stop parsing.
				
				if (!ShapeFileUtil.isValidRecordType(shapeFileRecord.type))
				{
					break;
				}
				
				switch (shapeFileRecord.type)
				{
					case ShapeFileContentTypes.MULTIPOINT:
						shapeFileRecord.content = parseMultiPoint(byteArray);
						break;
					case ShapeFileContentTypes.POINT:
						shapeFileRecord.content = parsePoint(byteArray);
						break;
					case ShapeFileContentTypes.POLYGON:
						shapeFileRecord.content = parsePolygon(byteArray);
						break;
					case ShapeFileContentTypes.POLYGON_M:
						shapeFileRecord.content = parsePolygonM(byteArray);
						break;
					case ShapeFileContentTypes.POLYGON_Z:
						shapeFileRecord.content = parsePolygonZ(byteArray);
						break;
					case ShapeFileContentTypes.POLYLINE:
						shapeFileRecord.content = parsePolyline(byteArray);
						break;
					case ShapeFileContentTypes.POLYLINE_M:
						shapeFileRecord.content = parsePolylineM(byteArray);
						break; 
					case ShapeFileContentTypes.POLYLINE_Z:
						shapeFileRecord.content = parsePolylineZ(byteArray);
						break;
					default:
						break;
				}
					
				shapeFile.records.push(shapeFileRecord);
			}
		}
	}
}