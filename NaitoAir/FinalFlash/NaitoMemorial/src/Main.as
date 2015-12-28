package 
{
	import caurina.transitions.properties.DisplayShortcuts;
	import core.AppController;
	import core.Locator;
	import core.StageController;
	import events.StateChangeEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.Mouse;
	import model.states.AppState;
	import model.vo.ContentVO;
	import view.AttractView;
	import view.Debug;

	import view.UI;
	
	/**
	 * ...
	 * @author Nina Pavlich 
	 */
	public class Main extends Sprite 
	{
		protected var ui:UI;
		protected var debug:Debug;
		public function Main():void 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		protected function init(ev:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Locator.init(); //holder of all global things
			
			StageController.init(stage);
			DisplayShortcuts.init();

			ui = new UI();
			addChild(ui);
			
			debug = new Debug();
			Locator.debug = debug
			debug.visible = false;
			addChild(debug);
			

			
			AppController.init(); //registering events and commands with front controller
			
			
			Locator.appState.addEventListener(StateChangeEvent.STATE_CHANGE, onStateChange);
			
		}
		protected function onStateChange(ev:StateChangeEvent):void {
			
			switch( ev.newState )
			{	
				
				case AppState.CREATION:
				
			
					var r:Number = Locator.config.appRotation;
					if (r == 1) {
						this.rotation = 90;
						this.x = Locator.config.applicationDimensions.height;
					}else if (r == 2) {
						this.rotation = 180;
						this.y = Locator.config.applicationDimensions.height;
						this.x = Locator.config.applicationDimensions.width
					}else if (r == 3) {
						this.rotation = -90;
						this.y = Locator.config.applicationDimensions.width
					}
					
					ui.scaleX = ui.scaleY = Locator.config.kiosk_scale;					
					debug.visible = Locator.config.debugMode;					
					
				break;
			
			}
		}
		
		
	}
	
}