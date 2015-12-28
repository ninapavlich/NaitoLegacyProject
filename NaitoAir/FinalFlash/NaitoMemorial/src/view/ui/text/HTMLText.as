package view.ui.text
{
	import core.Locator;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class HTMLText extends TextField
	{
		public static var cssStyleSheet:StyleSheet;
		protected var _default_style :String;
		protected var _text:String;
		
		
		public function HTMLText(style:String="", txt:String="") 
		{
			super();
			autoSize = TextFieldAutoSize.LEFT;
			_default_style = style;
			text = txt;
			embedFonts = true;
			
		}
		override public function get text():String { return super.text; }
		
		override public function set text(value:String):void 
		{
			_text = value;
			var str:String = "<span class='" + _default_style + "'>" + _text + "</span>";
			this.styleSheet = Locator.styles;
			this.htmlText = str
			
			
		}
		public function set default_style(inString:String):void {
			_default_style = inString;
			text = _text;
		}
	}
	
}