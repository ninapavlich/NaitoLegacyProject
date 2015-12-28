package view 
{
	import core.Locator;
	import events.AppEvent;
	import events.Dispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import model.states.*;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class AttractView extends AbstractView
	{
		
		//ATTRACT VIEW doesn't have any visual elements, but listens to the stage clicks to set / reset the attract timeout timer
		
		protected var _attractTimer:uint;
		protected var _attractTime:uint;

		
		public function AttractView() 
		{
			super();
			this.openState = AppState.ATTRACT;
			
			
		}
		protected function toOverview():void
		{
			Dispatcher.getInstance().dispatchEvent(new Event(AppEvent.TO_OVERVIEW));
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
			
			_attractTime = Locator.config.attract_timeout
					
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPress, false, 0, true);
			
			
		}
		
	
		protected function onButtonPress(ev:MouseEvent):void {
			//we are not sending this mouse event directly to the uicontroller because we want to reset the activity timeout
			resetActivityTimer();
			
			Locator.uiController.onAttractDown(ev);
		}
		protected function resetActivityTimer():void {
			clearTimeout(_attractTimer);
			_attractTimer = setTimeout(kioskInactive, _attractTime);
		}
		protected function kioskInactive():void {
			Locator.appState.currentState = AppState.ATTRACT;
		}
		override protected function open():void 
		{
			super.open();
		}
		
	}
	
}