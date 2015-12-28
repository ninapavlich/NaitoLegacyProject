package command 
{
	import core.Locator;
	import flash.events.Event;
	import model.states.AppState;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 */
	public class ToAttractCommand extends AbstractCommand
	{
		
		public function ToAttractCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			Locator.appState.currentState = AppState.ATTRACT
			super.execute(ev);
		}
		override public function onComplete():void 
		{
			
			super.onComplete();
		}
	}
	
}