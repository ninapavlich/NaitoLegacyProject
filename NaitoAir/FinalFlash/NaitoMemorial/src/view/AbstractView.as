package view 
{
	import core.Locator;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import model.vo.ContentVO;
	import model.states.AppState;
	import view.ui.BaseSprite
	
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * 
	 */
	
	public class AbstractView extends BaseSprite
	{
		protected var appState:AppState;
		protected var content:ContentVO;
	
		protected var _open:Boolean = false;
		protected var openState:String;
		
		protected var _hmargin:Number;
		protected var _vmargin:Number;
		
		protected var _background:Sprite;
		protected var _holder:Sprite;
		
		protected var _backgroundHeight:Number = 0;
		public function get backgroundHeight():Number {
			return _holder.height + (2 * _vmargin);
		}
		public function set backgroundHeight(inN:Number):void{
			_backgroundHeight = inN;
			invalidateView();
		}
		
		public function get viewableHeight():Number {
			return _backgroundHeight;
		}
		
		public function AbstractView() 
		{
			super();
			_open  = visible = false;
			appState = Locator.appState;
			content = Locator.content;
			appState.addEventListener(StateChangeEvent.STATE_CHANGE, onStateChange);
		}
		protected function config():void {
			_hmargin = Locator.config.hmargin;
			_vmargin = Locator.config.vmargin;
		}
		override protected function createChildren():void 
		{
			config();
		
			_background = new Sprite();
			addChild(_background);
			
			_holder = new Sprite();
			addChild(_holder);
			
			super.createChildren();
		}
		protected function onStateChange(ev:StateChangeEvent):void {
			//debug("onStateChange()", ev.newState);
			switch( ev.newState )
			{
				
				case AppState.CREATION:
					createChildren();
					
				break;
				
				case openState:
					open();
				break;
				
				default: 
					close();
				break;
			}
		}
		protected function open():void {
			visible = true;
			invalidateView();
		}
		protected function close():void {
			visible = false;
		}
	
	
	}
}
