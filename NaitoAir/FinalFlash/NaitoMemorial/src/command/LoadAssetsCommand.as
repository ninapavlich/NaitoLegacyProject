package command 
{
	import core.Locator;
	import flash.events.Event;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * This will load UI elements and assets like that
	 */
	
	public class LoadAssetsCommand extends AbstractCommand
	{
		
		public function LoadAssetsCommand() 
		{
			debug("LoadAssetsCommand");
			
		}
		override public function execute(ev:Event):void 
		{

			
			Locator.assets.addItems(Locator.content.preloadAssets);
			Locator.assets.addEventListener(Event.COMPLETE, onLoadComplete);
			Locator.assets.load();
			
		}
		protected function onLoadComplete(ev:Event):void {
			//trace("Loading assets complete");
			Locator.assets.removeEventListener(Event.COMPLETE, onLoadComplete);
			onComplete();
		}
		
	}
	
}
