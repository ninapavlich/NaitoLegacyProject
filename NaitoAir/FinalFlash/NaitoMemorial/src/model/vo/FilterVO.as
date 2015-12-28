package model.vo 
{
	import adobe.utils.CustomActions;
	import core.Locator;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * @author Nina Pavlich
	 * 
	 * @overview
	 *
	 * 
	 */
	
	public class FilterVO extends BaseVO
	{
		protected var _name:String;
		public function get name():String { return _name }
		public function get cleanName():String {
			var outstr:String = _name;
			
			while (outstr.indexOf(" ") >= 0) {
				outstr = outstr.replace(" ", "");
			}
			return outstr;
		}
		
		
		protected var _description:String;
		public function get description():String { return _description }
		
		protected var _color:String;
		public function get color():String { return _color }
		public function get cleanColor():uint {
			return uint("0x" + _color.substr(1));
		}
		
		protected var _image:String;
		public function get image():String { return _image }
		
		public function get randomStory():StoryVO {
			return StoryVO(_stories[Math.floor(Math.random()*_stories.length)]);
		}
		protected var _stories:Array = [];
		public function get stories():Array {
			return _stories
		}
		public function get storyNames():Array {
			var outA:Array = [];
			for each(var vo:StoryVO in _stories) {
				outA.push(vo.name);
			}
			return outA;
		}
		
		
		public function FilterVO(inXML:XML) 
		{
			_type = BaseVO.FILTER
			_name = inXML.name[0];
			
			_description = inXML.description[0];
			_color = inXML.color[0];
		
			_image = Locator.config.contentBaseURL + inXML.image[0];
			
			
			var slist:XMLList = inXML.stories[0].story;
			var prev:StoryVO;
			for each(var sitem:XML in slist) {
				var s:StoryVO = new StoryVO(sitem);
				s.filter = this;
				if (prev) {
					prev.next = s;
					s.previous = prev;
					
				}
				_stories.push(s);
				prev = s;
			}
			
			
			
		}
		
		//return assets and icon
		public function get preloadAssets():Array {
			var out:Array = [];
			for each(var story:StoryVO in _stories) {
				out = out.concat(story.preloadAssets);
			}
			out.push(_image);
			return out;
		}
		public function get slideshow():Array {
			return [_image];
		}
		public function get frontAsset():Bitmap {
			return Locator.assets.copyBitmap(this._image);			
		}
		public function get firstStory():StoryVO {
			return _stories[0];
		}
		public function toString():String 
		{
			return "FilterVO "+_name
		}
		
	}
	
	/**
	 * Before you hit the road, 
	 * please commend your code
	 * or all your RegionVOs will explode
	 */
}
