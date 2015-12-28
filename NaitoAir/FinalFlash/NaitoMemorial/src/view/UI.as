package view 
{
	
	import core.Locator;
	import events.StateChangeEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import model.states.AppState;
	import util.GestureUtility;
	import view.ImageView;
	import view.PreloaderView;
	import view.ui.embedded.Fonts;
	import view.ui.embedded.GUI;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class UI extends Sprite
	{
		
		public function UI() 
		{
			
			Locator.appState.addEventListener(StateChangeEvent.STATE_CHANGE, onStateChange);
			Locator.ui = this;
			
			addChild(new PreloaderView());
			
			
		}
		
		protected function onStateChange(ev:StateChangeEvent):void {
			
			switch( ev.newState )
			{	
				
				case AppState.CREATION:
					new GUI();
					Fonts.init(); 
					addChild(new MapView());		
					
					addChild(new ImageView());
					addChild(new AttractView());
					addChild(new NavView());
					
					
					GestureUtility.instance.initStage(this.stage);
			
				break;
			
			}
		}
		
	}
	
}