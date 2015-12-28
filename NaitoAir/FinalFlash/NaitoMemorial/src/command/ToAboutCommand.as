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
	
	public class ToAboutCommand extends AbstractCommand
	{
		
		public function ToAboutCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			Locator.appState.currentState = AppState.ABOUT
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
	 * or all your ToAboutCommands will explode
	 */
}
