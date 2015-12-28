package command 
{
	import core.Locator;
	import flash.events.Event;
	import model.states.AppState;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ToOverviewCommand extends AbstractCommand 
	{
		
		public function ToOverviewCommand() 
		{
		}
		override public function execute(ev:Event):void 
		{
			Locator.appState.currentState = AppState.OVERVIEW;
			super.execute(ev);
		}
		override public function onComplete():void 
		{
			
			super.onComplete();
		}
	}
	
}