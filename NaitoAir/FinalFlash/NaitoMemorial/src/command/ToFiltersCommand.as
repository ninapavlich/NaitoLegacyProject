package command 
{
	import core.Locator;
	import flash.events.Event;
	import model.states.AppState;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class ToFiltersCommand extends AbstractCommand
	{
		
		public function ToFiltersCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			
			Locator.appState.currentState = AppState.FILTERS
			super.execute(ev);
		}
		override public function onComplete():void 
		{
			
			super.onComplete();
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your ToFiltersCommands will explode
	 */
}
