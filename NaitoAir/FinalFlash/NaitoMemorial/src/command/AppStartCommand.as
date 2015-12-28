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
	
	public class AppStartCommand extends AbstractCommandQueue
	{
		
		public function AppStartCommand() 
		{
			commands=[LoadConfigCommand, LoadContentCommand, LoadAssetsCommand, LoadCSSCommand]
		}
		override public function execute(ev:Event):void 
		{
			trace("EXECUTE AppStartCommand");
			Locator.appState.currentState = AppState.LOADING;
			super.execute(ev);
		}
		override public function onComplete():void 
		{
			trace("AppStartCommand: onComplete()");
			Locator.appState.currentState = AppState.CREATION;
			Locator.appState.currentState = AppState.ATTRACT;
			super.onComplete();
		}
	}
	

}
