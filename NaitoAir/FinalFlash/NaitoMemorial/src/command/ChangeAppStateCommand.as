package command 
{
	import core.Locator;
	import events.AppEvents;
	import flash.events.Event;
	import model.states.AppState;;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * not using this
	 * 
	 */
	
	public class ChangeAppStateCommand extends AbstractCommand
	{
		
		public function ChangeAppStateCommand() 
		{
			super();
		}
		override public function execute(event:Event):void 
		{
			//trace("ChangeAppStateCommand: execute()", event.type);
			switch( event.type ) 
			{
				case AppEvents.TO_ATTRACT:
					Locator.appState.currentState = AppState.ATTRACT;
				break;
				case AppEvents.TO_OVERVIEW:
					Locator.appState.currentState = AppState.OVERVIEW;
				break;
				case AppEvents.TO_REGION:
					Locator.appState.currentState = AppState.REGION;
				break;
				case AppEvents.TO_STORY:
					Locator.appState.currentState = AppState.STORY;
				break;
				case AppEvents.TO_SECTION:
					Locator.appState.currentState = AppState.STORY;
				break;
			}
		}
		
	}

}
