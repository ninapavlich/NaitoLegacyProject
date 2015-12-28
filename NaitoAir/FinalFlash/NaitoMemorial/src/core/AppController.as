package core 
{
	import command.*;
	import events.AppEvent;
	import events.Dispatcher;
	import events.StateChangeEvent;
	import flash.events.Event;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * bind event constants to command classes in the FrontController
	 * init() // adds commands to the FrontController for the different types of events; Each of the event types are a kind of Command.
	 */
	
	public class AppController 
	{
		
		public static function init():void
		{
			
			var fc:SingletonFrontController = SingletonFrontController.instance;
			
		
			fc.addCommand(AppEvent.LOADING, AppStartCommand);
			fc.addCommand(AppEvent.TO_ATTRACT, ToAttractCommand);
			fc.addCommand(AppEvent.TO_ABOUT, ToAboutCommand);
			fc.addCommand(AppEvent.TO_OVERVIEW, ToOverviewCommand);
			fc.addCommand(AppEvent.TO_FILTERS, ToFiltersCommand);
			fc.addCommand(AppEvent.TO_FILTER, ToFilterCommand);
			fc.addCommand(AppEvent.TO_STORY, ToStoryCommand);
			fc.addCommand(AppEvent.TO_IMAGE, LoadImageCommand);
			
			
			Dispatcher.getInstance().dispatchEvent(new Event(AppEvent.LOADING));
			
		}
		
	}
	
	
}
