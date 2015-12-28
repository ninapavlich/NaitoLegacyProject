package view 
{
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.getTimer;
	import model.states.AppState;
	import view.ui.text.BaseText;
	import view.ui.text.HTMLText;
	/**
	 * ...
	 * @author ...
	 */
	public class Debug extends Sprite
	{
		protected var _field:TextField;
		protected var _bg:Sprite;
		public function Debug() 
		{
			
			_bg = new Sprite();
			_bg.graphics.beginFill(0xffffff, 1);
			_bg.graphics.drawRect(0, 0, 420, 220);
			_bg.graphics.endFill();
			addChild(_bg);
		
			_field = new TextField();
			
			addChild(_field);
			
			_field.wordWrap =
			_field.multiline = true;
			_field.border = true;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.type = TextFieldType.INPUT;
			_field.x = _field.y = 10
			_field.width = 400;

		}
		public function print(str:String = null):void {
			if(str){
				_field.appendText("[" + getTimer() + "] :: " + str + "\n");
				_field.setSelection(_field.text.length - 10, _field.text.length - 1);
				_field.y = 200 - _field.textHeight;
			}
			
		}
		
	}

}