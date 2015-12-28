package command 
{
	import core.Locator;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * This loads the content
	 */
	
	public class LoadContentCommand extends AbstractLoadCommand
	{
		
		public function LoadContentCommand() 
		{
			debug("LoadContentCommand"); 
			load("content.xml");
		}
		override protected function parse(object:Object):void 
		{
			
			var inXML:XML = XML(object);
			Locator.content.init(inXML);
			onComplete();
		}
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your LoadContentCommands will explode
	 */
}
