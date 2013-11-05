package widgets.Print.element
{
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.Label;

	public class TextElement extends Element
	{
		
		
		public function TextElement(printContent:UIComponent)
		{
			super(printContent);
			this.type=Element.TEXT_TYPE;
			this.toolTip="点击拖动";
			this.draggable=true;
			this.resizable=false;
			this.deleteable=true;
			_label=new Label();
			this.addElement(_label);
		}
		
		private var _label:Label;
		
		
		
		[Bindable]
		public function set text(value:String):void
		{
			if(_label!=null)
			{
				_label.text=value;
			}
		}
		
		public function get text():String
		{
			if(_label!=null)
			{
				return _label.text;
			}
			return "";
		}
		
		[Bindable]
		public function set fontFamily(value:String):void
		{
			if(_label!=null)
			{
				_label.setStyle("fontFamily",value);
			}
		}
		
		public function get fontFamily():String
		{
			if(_label!=null)
			{
				return _label.getStyle("fontFamily");
			}
			return "";
		}
		
		[Bindable]
		public function set fontSize(value:String):void
		{
			if(_label!=null)
			{
				_label.setStyle("fontSize",value);
			}
		}
		
		public function get fontSize():String
		{
			if(_label!=null)
			{
				return _label.getStyle("fontSize");
			}
			return "";
		}
		[Bindable]
		public function get color():String
		{
			if(_label!=null)
			{
				return _label.getStyle("color");
			}
			return "";
		}
		
		public function set color(value:String):void
		{
			if(_label!=null)
			{
				_label.setStyle("color",value);
			}
		}

		[Bindable]
		public function set fontWeight(value:String):void
		{
			if(_label!=null)
			{
				_label.setStyle("fontWeight",value);
			}
		}
		
		public function get fontWeight():String
		{
			if(_label!=null)
			{
				return _label.getStyle("fontWeight");
			}
			return "";
		}
		
		[Bindable]
		public function set fontStyle(value:String):void
		{
			if(_label!=null)
			{
				_label.setStyle("fontStyle",value);
			}
		}
		
		public function get fontStyle():String
		{
			if(_label!=null)
			{
				return _label.getStyle("fontStyle");
			}
			return "";
		}
	}
}