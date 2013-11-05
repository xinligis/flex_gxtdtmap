package com.esri.viewer.components.sho.core {
	import com.esri.viewer.components.sho.core.LoopResult;
	import mx.collections.*;
	
	public class Func {
		public static function apply(array: Array, func: Function) : void
		{
			for each (var elem: Object in array)
			{
				var result : LoopResult = func(elem);
				if (result == LoopResult.STOP)
					return;
			}
		}
		
		public static function map(array: Array, func: Function) : Array
		{
			if (array == null)
				return null;

			if (func == null)
				return array.concat();

			var length : int = array.length;
			var result : Array = new Array(length);
			
			for (var i : int = 0; i < length; i++)
			{
				result[i] = func(array[i]);
			}
			
			return result;
		}
		
		public static function mapCollection(collection: ICollectionView, func: Function) : Array
		{
			if (collection == null)
				return null;

			var iterator : IViewCursor = collection.createCursor();
			
			var result : Array = new Array();
			var i : int = 0;
			
			if (iterator.current)
			{
				do
				{
					// Add the item to the array.
					result.push( func(iterator.current) );
				} while (iterator.moveNext());
			}
	
			return result;
		}
		
		public static function combine(func1: Function, func2: Function) : Function
		{
			return function(param: *) : * { return func1(func2(param)); }
		}

		public static function combine1of2(func1: Function, func2: Function) : Function
		{
			return function(p1: *, p2: *) : * { return func1(func2(p1), p2); }
		}
		
		public static function combine2of2(func1: Function, func2: Function) : Function
		{
			return function(p1: *, p2: *) : * { return func1(p1, func2(p2)); }
		}
	}
}