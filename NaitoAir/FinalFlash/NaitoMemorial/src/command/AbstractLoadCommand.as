package command 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class AbstractLoadCommand extends AbstractCommand
	{
		protected var _loader:URLLoader;
		protected var _url:String
		
		public function AbstractLoadCommand() 
		{
			super();
		}
		public function load(inURL:String):void {
			_url = inURL;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.load(new URLRequest(_url));
		}
		protected function onLoadComplete(ev:Event):void {
			parse(_loader.data);
		}
		protected function parse(object:Object):void {
			
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your AbstractLoadXMLCommands will explode
	 */
}
