package widgets.Search
{
	import spark.components.RadioButton;
	
	[Style(name="normalImage", inherit="no", type="Class")]
	[Style(name="overImage", inherit="no", type="Class")]
	[Style(name="selectedImage", inherit="no", type="Class")]
	public class CustomRadioButton extends RadioButton
	{
		public function CustomRadioButton()
		{
			super();
			setStyle("skinClass",CustomRadioButtonSkin);
			buttonMode = true;
		}
	}
}