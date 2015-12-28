package command 
{
	import command.IQueueable;
	import core.Locator;
	import flash.events.Event;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * * Base class for commands. 
			+ execute(ev:Event) //starts command
			+ addCallback (f:Function) //add a function to execute when done executing
			+ onComplete() //callback(); //call back function after command is done executing
	 * 
	 */
	
	public class AbstractCommand implements ICommand, IQueueable
	{
		public var callback:Function;
		
		public function AbstractCommand() 
		{
			
		}
		public function execute(ev:Event):void {
			
		}
		public function addCallback(f:Function):void {
			callback = f;
		}
		public function onComplete():void {
			if ( callback != null ) callback();
			
		}
		protected function debug(...args):void {
			Locator.debug.print(this+" : "+String(args));
		}
		protected function toString():String {
			return 'AbstractCommand'
		}
		
	}

}
