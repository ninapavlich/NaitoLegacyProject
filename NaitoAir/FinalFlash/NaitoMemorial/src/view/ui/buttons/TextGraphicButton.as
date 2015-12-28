package view.ui.buttons 
{
	import flash.display.DisplayObject;
	import view.ui.BaseSprite;
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class TextGraphicButton extends GraphicButton
	{
		protected var _textButton:BaseTextButton;
		public function get textButton():BaseTextButton { return _textButton }
		protected var _margin:Number = 10;
		public function TextGraphicButton(_graphic:BaseSprite, _text:BaseTextButton) 
		{
			super(_graphic)
			_textButton = _text;
			addChild(_textButton);
		}
		public function set text(inStr:String):void {
			_textButton.text = inStr;
			setMeasurements();
		}
		override protected function createChildren():void 
		{
			
			
			setMeasurements();
			
			//trace("textgraphicbutton width: "+w, _textButton.getWidth(), _textButton
			
			super.createChildren();
			
			_graphic.y = (h * 0.5);
			_graphic.x = _margin + (0.5 * _graphic.getWidth());
			_textButton.x = _graphic.x + (2*_margin)+ (0.5 * _graphic.getWidth());
			
		}
		protected function setMeasurements():void {
			w = _graphic.getWidth() + _textButton.textField.textWidth + (3*_margin);
			h = Math.max(_graphic.getHeight(), _textButton.textField.textHeight);
			
		}
	}

}