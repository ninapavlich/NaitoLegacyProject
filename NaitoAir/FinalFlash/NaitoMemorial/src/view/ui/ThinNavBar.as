package view.ui
{
	import core.Locator;
	import events.StateChangeEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import model.states.AppState;
	import view.AbstractView;
	import view.ui.text.SelectableTextButton;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 * Thin Nav Bar holds the INTRO EXPLORE and ABOUT buttons at the bottom of the screen
	 * 
	 */
	
	public class ThinNavBar extends AbstractView
	{
		protected var _aboutText:SelectableTextButton;
		protected var _beginText:SelectableTextButton;
		protected var _introText:SelectableTextButton;
		
		public function ThinNavBar() 
		{
			
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			_introText = new SelectableTextButton("nav_button_selected", "nav_button", "INTRO");
			_beginText = new SelectableTextButton("nav_button_selected", "nav_button", "EXPLORE");
			_aboutText = new SelectableTextButton("nav_button_selected", "nav_button", "ABOUT");
			
			
			
			_holder.addChild(_introText);
			_holder.addChild(_beginText);
			_holder.addChild(_aboutText);
			
			_beginText.x = (Locator.config.applicationDimensions.width * 0.5) - (_beginText.width * 0.5);
			_introText.x = _beginText.x - (_introText.width + _hmargin);
			_aboutText.x = _beginText.x + (_hmargin + _beginText.width);
			
			_beginText.y = _introText.y = _aboutText.y = _vmargin*0.5;
			
			_introText.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onIntroDown);
			_beginText.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onBeginDown);
			_aboutText.addEventListener(MouseEvent.MOUSE_DOWN, Locator.uiController.onAboutDown);
			
			var bev:BevelFilter = new BevelFilter(2, 90, 0xcccccc, .2, 0x000000, 0.35, 8, 8);
			//_background.filters = [bev]
		}
		override public function draw():void 
		{
			super.draw();
			_background.graphics.clear();
			_background.graphics.beginFill(0x191818);
			_background.graphics.drawRect(0, 0, Locator.config.applicationDimensions.width, _beginText.height + (_vmargin)+Locator.config.bezelOffset);
			_background.graphics.endFill();
			
			
		}
		protected function render_text_selection(about:Boolean, begin:Boolean, credit:Boolean):void {
			_aboutText.selected = credit;
			_beginText.selected = begin;
			_introText.selected = about;
		}
		override protected function onStateChange(ev:StateChangeEvent):void 
		{
			open();
			
			switch(ev.newState) {
				case AppState.ABOUT:
					_introText.selected = true;
					_beginText.selected = false;
					_aboutText.selected = false;
				break;
				case AppState.CREDITS:
					_introText.selected = false;
					_beginText.selected = false;
					_aboutText.selected = true;
				break;
				default:
					_introText.selected = false;
					_beginText.selected = true;
					_aboutText.selected = false;
				break;
			}
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ThinNavBars will explode
	 */
}
