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
	import flash.utils.ByteArray;

	/**
	 * The DBFField class represents a field in a dbase2 file.
	 * 
	 */	
	public class DBFField
	{
		/**
		 * The field data address.
		 */		
		public var address:uint = 0;
		
		/**
		 * The index field flag.
		 */		
		public var indexFlag:uint = 0;
		
		/**
		 * The length of the field, in bytes. 
		 */		
		public var length:uint = 0;
		
		/**
		 * Production flag. 
		 */		
		public var mdx:uint = 0;
		
		/**
		 * The name of the field. 
		 */		
		public var name:String = "";
		
		/**
		 * The amount of field decimals. 
		 */		
		public var numDecimals:int = 0;
		
		/**
		 * The set flag.
		 */		
		public var setFlag:uint = 0;
		
		/**
		 * The type of the field. 
		 */		
		public var type:String = "";
		
		/**
		 * Constructor 
		 * @param byteArray The ByteArray containing the dbase2 field.
		 * 
		 */		
		public function DBFField(byteArray:ByteArray)
		{
			var charCode:int = -1;
			
			while (charCode=byteArray.readUnsignedByte())
			{
				name += String.fromCharCode(charCode);
			}
			
			byteArray.position += 10 - name.length;
			
			type = String.fromCharCode(byteArray.readUnsignedByte());
			address = byteArray.readUnsignedInt();
			length = byteArray.readUnsignedByte();
			numDecimals = byteArray.readUnsignedByte();
			byteArray.position += 2;
			mdx = byteArray.readUnsignedByte();
			byteArray.position += 2;
			setFlag = byteArray.readUnsignedByte();
			byteArray.position += 7;
			indexFlag = byteArray.readUnsignedByte();
		}
	}
}