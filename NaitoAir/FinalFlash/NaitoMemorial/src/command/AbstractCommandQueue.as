package command 
{
	import command.IQueueable
	import flash.events.Event;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * 
	 */
	
	public class AbstractCommandQueue extends AbstractCommand
	{
		public var commands:Array = [];
		
		public function AbstractCommandQueue() 
		{
			
		}
		public function addCommand(c:Class):void {
			commands.push(c);
		}
		override public function execute(ev:Event):void 
		{
			playQueue();
		}
		public function playQueue(ev:Event = null):void {
			//trace("AbstractCommandQueue: playQueue()", commands.length);
			if (commands.length == 0) {
				onComplete();
				
			}else {
				
				var current:Class = commands.shift();
				var cmd:IQueueable = new current();
				cmd.addCallback(playQueue);
				cmd.execute(ev);
				
			}
		}
		override public function onComplete():void
		{
			commands = [];
			delete this;
		}
		
	}
}
