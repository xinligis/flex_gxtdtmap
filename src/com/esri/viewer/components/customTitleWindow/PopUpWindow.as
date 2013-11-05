package com.esri.viewer.components.customTitleWindow
{
	import spark.components.TitleWindow;

	[Style(name="closeButtonVisible", inherit="no", type="Boolean")]
	public class PopUpWindow extends TitleWindow
	{
		public function PopUpWindow()
		{
			super();
//			this.setStyle("backgroundColor", 0xf7f7f7);
			this.setStyle("skinClass",PopUpWindowSkin);
		}
	}
}