package core 
{
	import events.StateChangeEvent;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Mouse;
	import model.Config;
	import model.states.AppState;;
	import view.Debug;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * listens for resize events and timeout events from outer stage
	 * 
	 */
	
	public class StageController 
	{
		public static var stage:Stage;
		public static var appState:AppState;
		
		public static var _mouseVisible:Boolean = true;
		public static function set mouseVisible(inB:Boolean):void {
			_mouseVisible = inB;
			if (_mouseVisible) {
				Mouse.show();
			}else {
				Mouse.hide();
			}
		}
		public static function get mouseVisible():Boolean { return _mouseVisible }
		
		protected static var _isFullscreen:Boolean
		public static function get isFullscreen():Boolean { return _isFullscreen; }
		public static function set isFullscreen(value:Boolean):void 
		{
			_isFullscreen = value;
			if (_isFullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		
		
		public function StageController() 
		{
			
		}
		public static function init( _stage:Stage):void {
			stage = _stage;
			
			appState = Locator.appState;
			appState.addEventListener(StateChangeEvent.STATE_CHANGE, onStateChange);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			
			
		}
		
		protected static function onKeyDown(ev:KeyboardEvent):void {
			if(ev.keyCode==77){
				mouseVisible = !_mouseVisible;
			}
			if (ev.keyCode == 70) {
				isFullscreen = !_isFullscreen;
			}
			if (ev.keyCode == 68) {
				Locator.debug.visible = !Locator.debug.visible;
			}
			if (ev.keyCode == 65) {
				Locator.appState.currentState = AppState.ATTRACT;
			}
		}
		protected static function onStateChange(ev:StateChangeEvent):void {
			switch(ev.newState) {
				case AppState.CREATION:
					
				if(Locator.config.debugMode==false){
					stage.align = StageAlign.TOP_LEFT;
					stage.scaleMode = StageScaleMode.NO_SCALE;
					stage.nativeWindow.alwaysInFront = true;
					mouseVisible = false;
					isFullscreen = true;
				}
			
				
				break;
				case AppState.ATTRACT:
				
				break;
				case AppState.OVERVIEW:
				
				break;
				case AppState.FILTER:
				
				break;
				case AppState.STORY:
				
				break;
				default:
				
				break;
			}
		}
	}
	

}
