package command 
{
	import core.Locator;
	import events.AppEvent;
	import flash.events.Event;
	import model.states.AppState
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ToFilterCommand extends AbstractCommand 
	{
		
		public function ToFilterCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			super.execute(ev);
			var event:AppEvent = ev as AppEvent;
			Locator.appState.filter = event.filter;
			Locator.appState.currentState = AppState.FILTER;
		}
	}
	
}