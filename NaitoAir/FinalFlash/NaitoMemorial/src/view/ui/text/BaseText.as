package view.ui.text 
{
	import flash.text.TextField;
	import view.ui.BaseSprite
	import view.ui.BaseSprite;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class BaseText extends BaseSprite
	{
		protected var _textField:HTMLText;
		public function get textField():TextField{return _textField}
		protected var _default_style :String;
		
		protected var _text:String;
		public function set text(string:String):void {
			_textField.text = _text = string;
		}
		public function get text():String{return _textField.text}
		
		public function BaseText(style:String="", txt:String="") 
		{
			_default_style = style;
			_text = txt;
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			_textField = new HTMLText(_default_style, _text);
			addChild(_textField);
		}
		public function set style(string:String):void {
			_textField.default_style = string;
			_textField.text = _text;
		}
			
		
		
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your BaseTexts will explode
	 */
}
