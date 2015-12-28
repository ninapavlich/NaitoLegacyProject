package command 
{
	import core.Locator;
	
	/**
	 * 
	 * @author Nina Pavlich 
	 * 
	 * @overview
	 * 
	 * This loads the config file
	 */
	
	public class LoadConfigCommand extends AbstractLoadCommand
	{
		
		public function LoadConfigCommand() 
		{
			debug("LoadConfigCommand");
			load("config.xml");
		}
		override protected function parse(object:Object):void 
		{
			var inXML:XML = XML(object);
			Locator.config.init(inXML);
			Locator.assets.init(inXML);
			onComplete();
		}
		
	}

}
