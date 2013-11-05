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
package com.liberty.files.dbf
{
	import com.liberty.files.dbf.DBFField;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.StringUtil;

	/**
	 * The DBFParser class is for parsing dbase2 binary data into DBF instances.
	 * 
	 * @see com.libert.files.dbf.DBF
	 */	
	public class DBFParser
	{
		/**
		 * Field terminator value. 
		 */		
		public static const FIELD_TERMINATOR:uint = 0x0D;
		
		/**
		 * Parses the header of a dbase2 file. 
		 * @param byteArray The ByteArray containing the dbase2 binary data.
		 * @param dbf The DBF instance to store the parsed data.
		 * 
		 */		
		public static function parseHeader(byteArray:ByteArray, dbf:DBF):void
		{
			byteArray.endian = Endian.BIG_ENDIAN;
			
			dbf.version = byteArray.readByte();
			
			dbf.lastUpdatedYear = byteArray.readUnsignedByte();
			dbf.lastUpdatedMonth = byteArray.readUnsignedByte();
			dbf.lastUpdatedDay = byteArray.readUnsignedByte();
			
			byteArray.endian = Endian.LITTLE_ENDIAN;
			
			dbf.numRecords = byteArray.readUnsignedInt();
			dbf.bytesHeader = byteArray.readUnsignedShort();
			dbf.bytesRecord = byteArray.readUnsignedShort();
			
			byteArray.endian = Endian.BIG_ENDIAN;
			
			byteArray.position += 2;
			
			dbf.incompleteTransactions = byteArray.readUnsignedByte();
			dbf.encryption = byteArray.readUnsignedByte();
			
			byteArray.position += 12;
			
			dbf.mdx = byteArray.readUnsignedByte();
			dbf.language = byteArray.readUnsignedByte();
			
			byteArray.position += 2;
			
			while (byteArray.readByte() != FIELD_TERMINATOR)
			{
				byteArray.position--;
				
				dbf.fields.push(new DBFField(byteArray));
			}
			
			dbf.recordOffset = dbf.bytesHeader + 1;
			
			byteArray.position += 1;
		}
		
		/**
		 * 
		 * Parses the records of a dbase2 file. 
		 * @param byteArray The ByteArray containing the dbase2 binary data.
		 * @param dbf The DBF instance to store the parsed data.
		 * 
		 */		
		public static function parseRecords(byteArray:ByteArray, dbf:DBF):void
		{
			while (byteArray.bytesAvailable)
			{
				var object:Object = new Object();
				
				for each (var dbfField:DBFField in dbf.fields)
				{
					var value:String = byteArray.readMultiByte(dbfField.length, "gbk2312");
					object[dbfField.name] = parseValue(value, dbfField);
				}
				
				dbf.records.addItem(object);
					
				byteArray.position += 1;
			}
		}
		/**
		 * 解析数值
		 */
		protected static function parseValue(value:String, dbfField:DBFField):*
		{
			value = StringUtil.trim(value);
			switch(dbfField.type)
			{
				case "F":
					return Number(value);
				case "N":
					return parseInt(value);
				case "C":
				case "M":
				case "G":
					return value;
					break;
				case "D":
					return parseDateTime(value);
					break;
				default:
					return value;
			}
		}
		/**
		 * 解析时间
		 */
		protected static function parseDateTime(value:String):Date
		{
			var year:int = parseInt(value.substr(0, 4));
			var month:int = parseInt(value.substr(4, 2));
			var day:int = parseInt(value.substr(6, 2));
			return new Date(year, month, day);
		}
	}
}