package model.vo 
{
	import core.Locator;
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class ImageVO 
	{
		
		protected var _source:String;
		public function get source():String { return _source}
		
		protected var _caption:String;
		public function get caption():String { return _caption}
		
		public function get asset():String { return _source; }
		
		public function get imageIndex():int { return _imageIndex; }
		public function set imageIndex(value:int):void {_imageIndex = value;}
		protected var _imageIndex:int = -1
		
		protected var _storyVO:StoryVO
		public function get storyVO():StoryVO { return _storyVO; }
		public function set storyVO(value:StoryVO):void { _storyVO = value; }
		
		protected var _arduino_id:int
		public function get arduino_id():int { return _arduino_id; }
		public function set arduino_id(value:int):void { _arduino_id = value;}
		
		
		public function ImageVO(source:String, caption:String, aid:int=-1) 
		{
			
			_source = source;
			_caption = caption;
			_arduino_id = aid;
			
		}
		public static function createMissingImageVO():ImageVO {
			return new ImageVO(Locator.config.contentBaseURL+"missing.jpg","Image Missing")
		}
		public static function createFromXML(inXML:XML):ImageVO{
			return new ImageVO(Locator.config.contentBaseURL+inXML.@src,inXML.@caption)
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your SectionVOs will explode
	 */
}
