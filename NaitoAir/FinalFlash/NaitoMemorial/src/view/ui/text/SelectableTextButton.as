package view.ui.text 
{
	import flash.filters.GlowFilter;
	import util.GestureEvent;
	import util.GestureUtility;
	import view.ui.buttons.BaseTextButton;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class SelectableTextButton extends BaseTextButton
	{
		protected var _selected_style:String;
		protected var _unselected_style:String;
		protected var _glow:GlowFilter
		
		protected var _selected:Boolean = false;
		public function set selected(inB:Boolean):void {
			_selected = inB;
			if (_selected) {
				style = _selected_style;		
				this.filters = [_glow];
			}else {
				style = _unselected_style;
				this.filters = null;
			}
		}
		
		public function SelectableTextButton(selectedstyle:String="", unselectedstyle:String="", txt:String="") 
		{
			
			_glow = new GlowFilter(0xffffff, .3, 8, 8);
			_selected_style = selectedstyle;
			_unselected_style = unselectedstyle;
			super(unselectedstyle, txt);
			mouseChildren = false;
			GestureUtility.instance.addListener(this, onDown, GestureEvent.DRAG_START);
			GestureUtility.instance.addListener(this, onUp, GestureEvent.DRAG_COMPLETE);
		}
		protected function onDown(ev:GestureEvent):void {
			if (!_selected) {
				this.filters = [_glow];
			}
		}
		protected function onUp(ev:GestureEvent):void {
			if (!_selected) {
				this.filters = null;
			}
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your SelectableTextButtons will explode
	 */
}
