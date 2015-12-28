package model.vo 
{
	import core.Locator;
	
	/**
	 * ...
	 * @author Nina Pavlich
	 * 
	 * MapIconVO is the location and source of story's .png on the map.
	 */
	public class MapIconVO 
	{
		
		protected var _x:Number;
		public function get x():Number { return _x }
		
		protected var _y:Number;
		public function get y():Number { return _y }
		
		protected var _source:String;
		public function get source():String{return _source}
		public function MapIconVO(inXML:XML) 
		{
				
			_x =  inXML.@x;
			_y = inXML.@y;
			_source = Locator.config.mapIconBaseURL + inXML.toString();
			
				
			
		}
		
	}
	
}