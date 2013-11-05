package com.esri.viewer.components
{
	/**
	 * @Wang Hongliang
	 * @E-mail: wanghl@esrichina-bj.cn
	 * @version 1.0.0
	 * 创建时间：2011-7-6 下午02:34:44
	 *
	 */
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	public class FlowLayout extends LayoutBase
	{
		public var gapColumn:Number = 0; //同一行的各个列之间的空隙
		public var gapRow:Number = 0; //各个行之间的间隙
		public function FlowLayout()
		{
			super();
		}
		override public function updateDisplayList
			(containerWidth:Number, containerHeight:Number):void
		{
			// TODO: iterate over the elements of the container,
			// resize and position them.
			var layoutTarget:GroupBase = target;
			var count:int = layoutTarget.numElements;
			var x:Number = Number(layoutTarget.left);
			var y:Number = 0;
			for (var i:int = 0; i < count; i++)
			{
				// get the current element, we're going to work with the
				// ILayoutElement interface
				var element:ILayoutElement = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
				element.setLayoutBoundsSize(NaN, NaN);
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// Would the element fit on this line, or should we move
				// to the next line?
				if (x + elementWidth > containerWidth)
				{
					// Start from the left side
					x = Number(layoutTarget.left);
					
					// Move down by elementHeight, we're assuming all 
					// elements are of equal height
					y += elementHeight + gapRow;
				} 
				
				// Position the element
				element.setLayoutBoundsPosition(x, y);
				// Update the current position, add a gap of 10
				x += elementWidth + gapColumn;
			}
		}
	}
}