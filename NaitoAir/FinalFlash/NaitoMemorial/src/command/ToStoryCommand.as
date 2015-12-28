package command 
{
	import core.Locator;
	import events.AppEvent;
	import flash.events.Event;
	import model.states.AppState;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ToStoryCommand extends AbstractCommand 
	{
		
		public function ToStoryCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			super.execute(ev);
			var event:AppEvent = ev as AppEvent;
			Locator.appState.story = event.story;
			Locator.appState.currentState = AppState.STORY;
		}
	}
	
}