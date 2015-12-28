package command 
{
	import core.Locator;
	import events.AppEvent;
	import events.Dispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import model.vo.ImageVO;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class LoadImageCommand extends AbstractCommand
	{
		protected var vo:ImageVO;
		public function LoadImageCommand() 
		{
			
		}
		override public function execute(ev:Event):void 
		{
			//if we've 
			
				Locator.appState.targetImageCommand = this;
				var appEvent:AppEvent = AppEvent(ev);
				vo = appEvent.image;
				Locator.assets.addItem(vo.source);
				Locator.assets.addEventListener(Event.COMPLETE, onLoadComplete);
				Locator.assets.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				Locator.assets.load();
		}
		protected function onLoadComplete(ev:Event):void {
			Locator.assets.removeEventListener(Event.COMPLETE, onLoadComplete);
			Locator.assets.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			
			if (Locator.appState.targetImageCommand != this) {
				Locator.debug.print('LoadImageCommand overriden');
				Locator.assets.releaseAsset(vo.source);
			}else{
				Locator.appState.image = vo;
			}
			
			onComplete();
			
		}
		protected function onIOError(ev:Event):void {
			debug("MISSING IMAGE ERROR")
			vo = ImageVO.createMissingImageVO();
			Locator.assets.addItem(vo.source);
			Locator.assets.load();
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your LoadImageCommands will explode
	 */
}
